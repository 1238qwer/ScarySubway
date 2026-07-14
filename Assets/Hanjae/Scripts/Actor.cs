using UnityEngine;

public class Actor : AnomalyBehaviour
{
    private enum ActorAnomalyType
    {
        Random,
        NeckRotate,
        JumpSquare
    }

    [SerializeField] private GameObject _head;
    [SerializeField] private Transform _jumpSquarePos;
    [SerializeField] private ActorAnomalyType _anomalyType = ActorAnomalyType.Random;

    [SerializeField] private float _shakeAmount = 0.03f;
    [SerializeField] private float _shakeSpeed = 80f;

    private float _rotateTime;
    private float _jumpTime;

    private bool _isRotating;
    private bool _isJumpSquare;

    private Vector3 _originPosition;
    private Quaternion _originRotation;
    private Transform _originParent;

    private Vector3 _jumpLocalPos;

    private void Start()
    {
        _originParent = transform.parent;
        _originPosition = transform.position;
        _originRotation = transform.rotation;
    }

    private void Update()
    {
        if (_isRotating)
        {
            _rotateTime += Time.deltaTime;

            if (_rotateTime > 10f)
            {
                _isRotating = false;
                if (_head != null)
                    _head.transform.localRotation = Quaternion.identity;

                _rotateTime = 0f;
            }
        }

        if (_isJumpSquare)
        {
            _jumpTime += Time.deltaTime;

            float x = Mathf.Sin(Time.time * _shakeSpeed) * _shakeAmount;
            float y = Mathf.Cos(Time.time * _shakeSpeed * 1.3f) * _shakeAmount;

            transform.localPosition = _jumpLocalPos + new Vector3(x, y, 0f);

            if (_jumpTime > 0.7f)
                ResetJumpState();
        }
    }

    public override void Activate()
    {
        ActorAnomalyType typeToRun = ResolveAnomalyType();

        if (typeToRun == ActorAnomalyType.NeckRotate)
            ActivateNeckRotate();
        else
            ActivateJumpSquare();
    }

    public override void Deactivate()
    {
        _isRotating = false;
        _rotateTime = 0f;

        if (_head != null)
            _head.transform.localRotation = Quaternion.identity;

        if (_isJumpSquare)
            ResetJumpState();
    }

    private ActorAnomalyType ResolveAnomalyType()
    {
        if (_anomalyType != ActorAnomalyType.Random)
            return _anomalyType;

        string id = AnomalyID != null ? AnomalyID.ToLowerInvariant() : string.Empty;

        if (id.Contains("neck"))
            return ActorAnomalyType.NeckRotate;

        if (id.Contains("jump"))
            return ActorAnomalyType.JumpSquare;

        return Random.value < 0.5f ? ActorAnomalyType.NeckRotate : ActorAnomalyType.JumpSquare;
    }

    private void ActivateNeckRotate()
    {
        if (_head == null || Camera.main == null)
            return;

        _head.transform.LookAt(Camera.main.transform.position);
        _isRotating = true;
    }

    private void ActivateJumpSquare()
    {
        if (_jumpSquarePos == null)
            return;

        transform.parent = _jumpSquarePos;
        _jumpLocalPos = Vector3.zero;
        transform.localPosition = _jumpLocalPos;
        transform.localRotation = Quaternion.identity;

        _isJumpSquare = true;
        _jumpTime = 0f;
    }

    private void ResetJumpState()
    {
        _isJumpSquare = false;

        transform.parent = _originParent;
        transform.position = _originPosition;
        transform.rotation = _originRotation;

        _jumpTime = 0f;
    }
}