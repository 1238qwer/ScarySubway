using UnityEngine;

public class ActorManager : MonoBehaviour
{
    [SerializeField] Actor[] _actors;

    [SerializeField] Transform _jumpSquarePos;
    public void ActorNeckRotateToPlayer()
    {
        _actors[Random.Range(0, _actors.Length)].NeckRotateToPlayer();
    }

    public void ActorJumpSquare()
    {
        _actors[Random.Range(0, _actors.Length)].JumpSquare(_jumpSquarePos);
    }
}
