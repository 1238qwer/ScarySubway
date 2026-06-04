using System.Collections.Generic;
using UnityEngine;

public class ActorManager : MonoBehaviour
{
    [SerializeField] private GameObject _actorPrefab;
    [SerializeField] private Transform[] _actorTransforms;
    [SerializeField] private Material[] _actorHeadMats;
    [SerializeField] private Material[] _actorBodyMats;
    [SerializeField] private Transform _jumpSquarePos;

    private Actor[] _actors;
    private readonly HashSet<Actor> _blackoutEventActors = new HashSet<Actor>();

    void Start()
    {
        SpawnActors();
    }

    void SpawnActors()
    {
        List<(Material head, Material body)> combinations =
            new List<(Material, Material)>();

        foreach (var head in _actorHeadMats)
        {
            foreach (var body in _actorBodyMats)
            {
                combinations.Add((head, body));
            }
        }

        for (int i = 0; i < combinations.Count; i++)
        {
            int rand = Random.Range(i, combinations.Count);
            (combinations[i], combinations[rand]) =
            (combinations[rand], combinations[i]);
        }

        _actors = new Actor[_actorTransforms.Length];

        for (int i = 0; i < _actorTransforms.Length; i++)
        {
            GameObject obj =
                Instantiate(
                    _actorPrefab,
                    _actorTransforms[i].position,
                    _actorTransforms[i].rotation,
                    transform);

            Actor actor = obj.GetComponent<Actor>();
            _actors[i] = actor;

            if (i < combinations.Count)
            {
                actor.SetMaterials(
                    combinations[i].head,
                    combinations[i].body);
            }
        }
    }

    public void ClearBlackoutEventActors()
    {
        _blackoutEventActors.Clear();
    }

    public bool WasBlackoutEventActor(Actor actor)
    {
        return actor != null && _blackoutEventActors.Contains(actor);
    }

    public void ActorNeckRotateToPlayer()
    {
        Actor actor = GetRandomActor();
        if (actor == null)
            return;

        _blackoutEventActors.Add(actor);
        actor.NeckRotateToPlayer();
    }

    public void ActorJumpSquare()
    {
        Actor actor = GetRandomActor();
        if (actor == null)
            return;

        _blackoutEventActors.Add(actor);
        actor.JumpSquare(_jumpSquarePos);
    }

    private Actor GetRandomActor()
    {
        if (_actors == null || _actors.Length == 0)
            return null;

        return _actors[Random.Range(0, _actors.Length)];
    }
}