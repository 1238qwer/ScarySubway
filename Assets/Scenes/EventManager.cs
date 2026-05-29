using UnityEngine;

public class EventManager : MonoBehaviour
{
    private ActorManager _actorManager;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _actorManager = Object.FindAnyObjectByType<ActorManager>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void StartActorEvent()
    {
        _actorManager.RotateActorNecToPlayer();
    }
}
