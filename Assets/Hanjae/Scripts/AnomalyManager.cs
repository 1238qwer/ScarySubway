using System.Collections.Generic;
using UnityEngine;

public class AnomalyManager : MonoBehaviour
{
    public static AnomalyManager Instance;

    private List<AnomalyBehaviour> anomalies =
        new List<AnomalyBehaviour>();

    private List<AnomalyBehaviour> activated =
        new List<AnomalyBehaviour>();

    private ActorManager _actorAnomalyManager;

    void Start()
    {
        Instance = this;
        _actorAnomalyManager = Object.FindAnyObjectByType<ActorManager>();
    }

    public void Register(AnomalyBehaviour anomaly)
    {
        anomalies.Add(anomaly);
    }

    void Update()
    {
    }

    public void StartStage(AnomalyData data)
    {
        ClearStage();

        foreach (var anomaly in anomalies)
        {
            if (anomaly.ID == data.anomalyID)
            {
                anomaly.Activate();
                activated.Add(anomaly);
            }
        }
    }

    public void ClearStage()
    {
        foreach (var anomaly in activated)
            anomaly.Deactivate();

        activated.Clear();
    }

    public void ActorNeckRotateToPlayer()
    {
        _actorAnomalyManager?.ActorNeckRotateToPlayer();
    }

    public void ActorJumpSquare()
    {
        _actorAnomalyManager?.ActorJumpSquare();
    }

    public void ClearBlackoutEventActors()
    {
        _actorAnomalyManager?.ClearBlackoutEventActors();
    }

    public bool WasBlackoutEventActor(Actor actor)
    {
        return _actorAnomalyManager != null && _actorAnomalyManager.WasBlackoutEventActor(actor);
    }

    public int GetActorCount()
    {
        return _actorAnomalyManager != null ? _actorAnomalyManager.GetActorCount() : 0;
    }
}
