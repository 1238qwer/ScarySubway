using UnityEngine;

public class EventManager : MonoBehaviour
{
    private ActorManager _actorManager;

    void Start()
    {
        _actorManager = Object.FindAnyObjectByType<ActorManager>();
    }

    void Update()
    {
    }

    public void ActorNeckRotateToPlayer()
    {
        _actorManager?.ActorNeckRotateToPlayer();
    }

    public void ActorJumpSquare()
    {
        _actorManager?.ActorJumpSquare();
    }

    public void ClearBlackoutEventActors()
    {
        _actorManager?.ClearBlackoutEventActors();
    }

    public bool WasBlackoutEventActor(Actor actor)
    {
        return _actorManager != null && _actorManager.WasBlackoutEventActor(actor);
    }
}
