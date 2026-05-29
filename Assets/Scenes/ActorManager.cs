using UnityEngine;

public class ActorManager : MonoBehaviour
{
    [SerializeField] Actor[] _actors; 
    public void RotateActorNecToPlayer()
    {
        _actors[Random.Range(0, _actors.Length)].RotateNecToPlayer();
    }
}
