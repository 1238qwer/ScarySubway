using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnomalyManager : MonoBehaviour
{
    public static AnomalyManager Instance;

    public List<AnomalyBehaviour> _registeredAnomalies = new List<AnomalyBehaviour>();
    private readonly List<AnomalyBehaviour> _activeAnomalies = new List<AnomalyBehaviour>();
    private readonly Dictionary<AnomalyBehaviour, Coroutine> _pendingActivations = new Dictionary<AnomalyBehaviour, Coroutine>();
    private readonly Dictionary<AnomalyBehaviour, bool> _currentStates = new Dictionary<AnomalyBehaviour, bool>();

    private void Awake()
    {
        Instance = this;
        RebuildRegisteredAnomalies();
    }

    private void RebuildRegisteredAnomalies()
    {
        _registeredAnomalies.Clear();

        AnomalyBehaviour[] all = Object.FindObjectsByType<AnomalyBehaviour>(FindObjectsSortMode.None);
        for (int i = 0; i < all.Length; i++)
        {
            AnomalyBehaviour anomaly = all[i];
            if (anomaly == null || !anomaly.isActiveAndEnabled)
                continue;

            Register(anomaly);
        }
    }

    public void Register(AnomalyBehaviour anomaly)
    {
        if (anomaly == null || _registeredAnomalies.Contains(anomaly))
            return;

        _registeredAnomalies.Add(anomaly);
    }

    public void Unregister(AnomalyBehaviour anomaly)
    {
        if (anomaly == null)
            return;

        _registeredAnomalies.Remove(anomaly);
        _activeAnomalies.Remove(anomaly);
        _currentStates.Remove(anomaly);

        if (_pendingActivations.TryGetValue(anomaly, out Coroutine routine))
        {
            if (routine != null)
                StopCoroutine(routine);

            _pendingActivations.Remove(anomaly);
        }
    }

    public void InitializeAnomalyStates()
    {
        StopAllPendingActivations();
        _activeAnomalies.Clear();
        _currentStates.Clear();

        for (int i = 0; i < _registeredAnomalies.Count; i++)
        {
            AnomalyBehaviour anomaly = _registeredAnomalies[i];
            if (anomaly == null)
                continue;

            bool startActive = Random.value < Mathf.Clamp01(anomaly.InitialActiveChance);
            ApplyState(anomaly, startActive);
        }
    }

    public void ClearStage()
    {
        StopAllPendingActivations();

        for (int i = 0; i < _registeredAnomalies.Count; i++)
        {
            AnomalyBehaviour anomaly = _registeredAnomalies[i];
            if (anomaly == null)
                continue;

            ApplyState(anomaly, false);
        }
    }

    private void ValidateRegisteredAnomalies()
    {
        if (_registeredAnomalies.Count == 0)
            Debug.LogError("[Anomaly] No registered anomalies. Check OnEnable/Register timing and active states.");
    }

    public bool TriggerRandomAnomaly()
    {
        ValidateRegisteredAnomalies();

        AnomalyBehaviour picked = PickWeightedRandomAnomaly();
        if (picked == null)
        {
            Debug.LogError("[Anomaly] Random selection failed. Reasons: no registered anomaly or total SelectionWeight <= 0.");
            return false;
        }

        if (string.IsNullOrWhiteSpace(picked.AnomalyID))
        {
            Debug.LogError("[Anomaly] Picked anomaly has empty ID: " + picked.name);
            return false;
        }

        bool triggered = TriggerAnomalyById(picked.AnomalyID);
        if (!triggered)
        {
            Debug.LogError("[Anomaly] TriggerAnomalyById failed for ID: " + picked.AnomalyID);
            return false;
        }

        return true;
    }

    private AnomalyBehaviour PickWeightedRandomAnomaly()
    {
        if (_registeredAnomalies.Count == 0)
            return null;

        float totalWeight = 0f;
        for (int i = 0; i < _registeredAnomalies.Count; i++)
        {
            AnomalyBehaviour a = _registeredAnomalies[i];
            if (a == null)
                continue;

            totalWeight += Mathf.Max(0f, a.SelectionWeight);
        }

        if (totalWeight <= 0f)
            return null;

        float roll = Random.value * totalWeight;

        for (int i = 0; i < _registeredAnomalies.Count; i++)
        {
            AnomalyBehaviour a = _registeredAnomalies[i];
            if (a == null)
                continue;

            float w = Mathf.Max(0f, a.SelectionWeight);
            if (w <= 0f)
                continue;

            if (roll < w)
                return a;

            roll -= w;
        }

        return null;
    }

    public bool TriggerAnomalyById(string anomalyID)
    {
        if (string.IsNullOrWhiteSpace(anomalyID))
        {
            Debug.Log("[Anomaly] none");
            return false;
        }

        bool triggered = false;

        for (int i = 0; i < _registeredAnomalies.Count; i++)
        {
            AnomalyBehaviour anomaly = _registeredAnomalies[i];
            if (anomaly == null || anomaly.AnomalyID != anomalyID)
                continue;

            bool target = !GetCurrentState(anomaly);

            if (anomaly.ActivateWhenOutOfFrustum)
            {
                if (_pendingActivations.TryGetValue(anomaly, out Coroutine oldRoutine) && oldRoutine != null)
                    StopCoroutine(oldRoutine);

                Coroutine routine = StartCoroutine(ActivateWhenOutOfFrustumRoutine(anomaly, target));
                _pendingActivations[anomaly] = routine;
            }
            else
            {
                ApplyState(anomaly, target);
            }

            Debug.Log("[Anomaly] selected: " + anomaly.AnomalyID + " -> " + (target ? "Active" : "Inactive"));
            triggered = true;
        }

        if (!triggered)
            Debug.Log("[Anomaly] none (selection failed)");

        return triggered;
    }

    private IEnumerator ActivateWhenOutOfFrustumRoutine(AnomalyBehaviour anomaly, bool targetState)
    {
        while (anomaly != null)
        {
            Camera cam = Camera.main;

            if (cam == null)
            {
                yield return null;
                continue;
            }

            if (anomaly.IsInPlayerFrustum(cam))
            {
                yield return null;
                continue;
            }

            break;
        }

        _pendingActivations.Remove(anomaly);

        if (anomaly == null)
            yield break;

        ApplyState(anomaly, targetState);
    }

    private void ApplyState(AnomalyBehaviour anomaly, bool active)
    {
        if (active)
            anomaly.Activate();
        else
            anomaly.Deactivate();

        _currentStates[anomaly] = active;

        if (active)
        {
            if (!_activeAnomalies.Contains(anomaly))
                _activeAnomalies.Add(anomaly);
        }
        else
        {
            _activeAnomalies.Remove(anomaly);
        }
    }

    private bool GetCurrentState(AnomalyBehaviour anomaly)
    {
        if (anomaly != null && _currentStates.TryGetValue(anomaly, out bool state))
            return state;

        return false;
    }

    private void StopAllPendingActivations()
    {
        foreach (KeyValuePair<AnomalyBehaviour, Coroutine> pair in _pendingActivations)
        {
            if (pair.Value != null)
                StopCoroutine(pair.Value);
        }

        _pendingActivations.Clear();
    }

    public bool TryResolveWithActor(Actor lookedActor)
    {
        for (int i = 0; i < _activeAnomalies.Count; i++)
        {
            if (_activeAnomalies[i].TryResolveWithActor(lookedActor))
                return true;
        }

        return false;
    }
}
