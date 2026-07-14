using System.Collections.Generic;
using UnityEngine;

public class DoorAnomaly : AnomalyBehaviour
{
    [SerializeField] private GameObject[] _doors;

    private const float ShakeChangeInterval = 0.06f;
    private const float ShakeLerpSpeed = 18f;

    private readonly List<Transform> _doorTransforms = new List<Transform>();
    private readonly List<Vector3> _baseLocalPositions = new List<Vector3>();
    private readonly List<float> _currentX = new List<float>();
    private readonly List<float> _targetX = new List<float>();

    private bool _isShaking;
    private float _shakeTimer;

    private void Awake()
    {
        CacheDoorTransforms();
        ApplyBaseState();
    }

    private void Update()
    {
        if (!_isShaking)
            return;

        _shakeTimer -= Time.deltaTime;
        if (_shakeTimer <= 0f)
            PickNextTargets();

        for (int i = 0; i < _doorTransforms.Count; i++)
        {
            Transform tr = _doorTransforms[i];
            if (tr == null)
                continue;

            _currentX[i] = Mathf.Lerp(_currentX[i], _targetX[i], ShakeLerpSpeed * Time.deltaTime);

            Vector3 basePos = _baseLocalPositions[i];
            tr.localPosition = new Vector3(_currentX[i], basePos.y, basePos.z);
        }
    }

    public override void Activate()
    {
        _isShaking = false;
        ApplyBaseState();
    }

    public override void Deactivate()
    {
        _isShaking = true;
        _shakeTimer = 0f;
        PickNextTargets();
    }

    private void CacheDoorTransforms()
    {
        _doorTransforms.Clear();
        _baseLocalPositions.Clear();
        _currentX.Clear();
        _targetX.Clear();

        if (_doors == null)
            return;

        for (int i = 0; i < _doors.Length; i++)
        {
            GameObject go = _doors[i];
            if (go == null)
                continue;

            Transform tr = go.transform;
            _doorTransforms.Add(tr);
            _baseLocalPositions.Add(tr.localPosition);
            _currentX.Add(tr.localPosition.x);
            _targetX.Add(tr.localPosition.x);
        }
    }

    private void ApplyBaseState()
    {
        for (int i = 0; i < _doorTransforms.Count; i++)
        {
            Transform tr = _doorTransforms[i];
            if (tr == null)
                continue;

            Vector3 basePos = _baseLocalPositions[i];
            tr.localPosition = basePos;
            _currentX[i] = basePos.x;
            _targetX[i] = basePos.x;
        }
    }

    private void PickNextTargets()
    {
        for (int i = 0; i < _doorTransforms.Count; i++)
        {
            if (i == 0)
                _targetX[i] = Random.Range(-0.3f, 0f);
            else if (i == 1)
                _targetX[i] = Random.Range(0f, 0.3f);
            else
                _targetX[i] = _baseLocalPositions[i].x;
        }

        _shakeTimer = ShakeChangeInterval;
    }
}
