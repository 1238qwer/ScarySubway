using System.Collections.Generic;
using UnityEngine;

public class AnomalyManager : MonoBehaviour
{
    public static AnomalyManager Instance;

    [SerializeField] private AnomalyData[] _anomalyPool;

    private readonly List<AnomalyBehaviour> _registeredAnomalies = new List<AnomalyBehaviour>();
    private readonly List<AnomalyBehaviour> _activeAnomalies = new List<AnomalyBehaviour>();

    private void Awake()
    {
        Instance = this;
    }

    public void Register(AnomalyBehaviour anomaly)
    {
        if (anomaly == null || _registeredAnomalies.Contains(anomaly))
            return;

        _registeredAnomalies.Add(anomaly);
    }

    public void Unregister(AnomalyBehaviour anomaly)
    {
        _registeredAnomalies.Remove(anomaly);
        _activeAnomalies.Remove(anomaly);
    }

    public void ClearStage()
    {
        for (int i = 0; i < _activeAnomalies.Count; i++)
            _activeAnomalies[i].Deactivate();

        _activeAnomalies.Clear();
    }

    public bool TriggerRandomAnomaly()
    {
        if (_anomalyPool == null || _anomalyPool.Length == 0)
            return false;

        AnomalyData picked = _anomalyPool[Random.Range(0, _anomalyPool.Length)];
        if (picked == null || string.IsNullOrWhiteSpace(picked.AnomalyID))
            return false;

        return TriggerAnomalyById(picked.AnomalyID);
    }

    public bool TriggerAnomalyById(string anomalyID)
    {
        if (string.IsNullOrWhiteSpace(anomalyID))
            return false;

        ClearStage();

        bool triggered = false;

        for (int i = 0; i < _registeredAnomalies.Count; i++)
        {
            AnomalyBehaviour anomaly = _registeredAnomalies[i];
            if (anomaly == null || anomaly.ID != anomalyID)
                continue;

            anomaly.Activate();
            _activeAnomalies.Add(anomaly);
            triggered = true;
        }

        return triggered;
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

    public void RespawnActorsOnHalfPositions()
    {
        ActorManager actorManager = Object.FindAnyObjectByType<ActorManager>();
        actorManager?.RespawnActorsOnHalfPositions();
    }
}
