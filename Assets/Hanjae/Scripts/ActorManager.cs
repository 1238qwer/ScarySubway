using System.Collections.Generic;
using UnityEngine;

public class ActorManager : AnomalyBehaviour
{
    private enum ActorAnomalyType
    {
        Random,
        NeckRotate,
        JumpSquare
    }

    [SerializeField] private GameObject[] _actorPrefabs;
    [SerializeField] private Transform[] _actorTransforms;
    [SerializeField] private Material[] _actorHeadMats;
    [SerializeField] private Material[] _actorBodyMats;
    [SerializeField] private Transform _jumpSquarePos;
    [SerializeField] private ActorAnomalyType _anomalyType = ActorAnomalyType.Random;

    private Actor[] _actors;
    private readonly HashSet<Actor> _anomalyActors = new HashSet<Actor>();

    private void Start()
    {
    }

    public void RespawnActorsOnHalfPositions()
    {
        ClearAnomalyActors();
        DestroyAllActors();
        SpawnActorsOnHalfPositions();
    }

    private void DestroyAllActors()
    {
        if (_actors == null)
            return;

        for (int i = 0; i < _actors.Length; i++)
        {
            if (_actors[i] != null)
                Destroy(_actors[i].gameObject);
        }

        _actors = null;
    }

    private void SpawnActorsOnHalfPositions()
    {
        if (_actorPrefabs == null || _actorPrefabs.Length == 0 || _actorTransforms == null || _actorTransforms.Length == 0)
        {
            _actors = new Actor[0];
            return;
        }

        int spawnCount = _actorTransforms.Length / 2;
        if (spawnCount <= 0)
        {
            _actors = new Actor[0];
            return;
        }

        List<int> indices = new List<int>(_actorTransforms.Length);
        for (int i = 0; i < _actorTransforms.Length; i++)
            indices.Add(i);

        for (int i = indices.Count - 1; i > 0; i--)
        {
            int swapIndex = Random.Range(0, i + 1);
            int temp = indices[i];
            indices[i] = indices[swapIndex];
            indices[swapIndex] = temp;
        }

        _actors = new Actor[spawnCount];

        for (int i = 0; i < spawnCount; i++)
        {
            Transform spawnPoint = _actorTransforms[indices[i]];
            if (spawnPoint == null)
                continue;

            GameObject actorObject =
                Instantiate(
                    _actorPrefabs[Random.Range(0, _actorPrefabs.Length)],
                    spawnPoint.position,
                    spawnPoint.rotation,
                    transform);

            _actors[i] = actorObject.GetComponent<Actor>();
        }
    }

    public void ClearAnomalyActors()
    {
        _anomalyActors.Clear();
    }

    public bool IsAnomalyActor(Actor actor)
    {
        return actor != null && _anomalyActors.Contains(actor);
    }

    public int GetActorCount()
    {
        return _actors != null ? _actors.Length : 0;
    }

    public override void Activate()
    {
        Actor target = GetRandomActorWithoutAnomaly();
        if (target == null)
            return;

        _anomalyActors.Clear();
        _anomalyActors.Add(target);

        ActorAnomalyType typeToRun = _anomalyType;
        if (typeToRun == ActorAnomalyType.Random)
            typeToRun = Random.value < 0.5f ? ActorAnomalyType.NeckRotate : ActorAnomalyType.JumpSquare;

        if (typeToRun == ActorAnomalyType.NeckRotate)
            target.NeckRotateToPlayer();
        else
            target.JumpSquare(_jumpSquarePos);
    }

    public override void Deactivate()
    {
        _anomalyActors.Clear();
    }

    public override bool TryResolveWithActor(Actor actor)
    {
        return IsAnomalyActor(actor);
    }

    private Actor GetRandomActorWithoutAnomaly()
    {
        if (_actors == null || _actors.Length == 0)
            return null;

        List<Actor> candidates = new List<Actor>();
        for (int i = 0; i < _actors.Length; i++)
        {
            Actor actor = _actors[i];
            if (actor != null && !_anomalyActors.Contains(actor))
                candidates.Add(actor);
        }

        if (candidates.Count == 0)
            return null;

        return candidates[Random.Range(0, candidates.Count)];
    }
}