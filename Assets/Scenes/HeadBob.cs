using UnityEngine;
using static LightManager;

public class HeadBob : MonoBehaviour
{
    public CharacterController controller;

    [SerializeField] private HeadBobPreset _preset;

    public float startDuration = 1f;
    public float loopDuration = 2f;
    public float endDuration = 1f;

    public float bobHeight = 0.1f;

    public float xRandomAmount = 0.2f;
    public float yRandomAmount = 0.05f;

    public float xNoiseSpeed = 2f;
    public float yNoiseSpeed = 3f;

    private float _defaultY;
    private float _defaultX;

    private float _timer;

    private float _xNoiseSeed;
    private float _yNoiseSeed;

    public enum BobState
    {
        Idle,
        Start,
        Loop,
        End
    }

    public BobState currentState = BobState.Idle;

    void Start()
    {
        _defaultY = transform.localPosition.y;
        _defaultX = transform.localPosition.x;

        _xNoiseSeed = Random.Range(0f, 999f);
        _yNoiseSeed = Random.Range(0f, 999f);
    }

    void Update()
    {
        switch (currentState)
        {
            case BobState.Start:
                PlayStart();
                break;

            case BobState.Loop:
                PlayLoop();
                break;

            case BobState.End:
                PlayEnd();
                break;

            case BobState.Idle:
                ResetPosition();
                break;
        }
    }

    public void StartBob()
    {
        _timer = 0f;
        currentState = BobState.Start;
    }

    public void StopBob()
    {
        _timer = 0f;
        currentState = BobState.End;
    }

    void PlayStart()
    {
        _timer += Time.deltaTime;

        float t = _timer / startDuration;

        float value = _preset.startCurve.Evaluate(t);

        ApplyPosition(value);

        if (t >= 1f || _preset.startCurve.keys[_preset.startCurve.length - 1].time <= t)
        {
            _timer = 0f;
            currentState = BobState.Loop;
        }
    }

    void PlayLoop()
    {
        _timer += Time.deltaTime;

        float t = (_timer % loopDuration) / loopDuration;

        float value = _preset.loopCurve.Evaluate(t);

        ApplyPosition(value);
    }

    void PlayEnd()
    {
        _timer += Time.deltaTime;

        float t = _timer / endDuration;

        float value = _preset.endCurve.Evaluate(t);

        ApplyPosition(value);

        if (_preset.endCurve.keys[_preset.endCurve.length - 1].time <= t)
        {
            _timer = 0f;
            currentState = BobState.Idle;
        }
    }

    void ApplyPosition(float value)
    {
        Vector3 pos = transform.localPosition;

        float xNoise =
            Mathf.PerlinNoise(
                _xNoiseSeed,
                Time.time * xNoiseSpeed
            ) * 2f - 1f;

        float yNoise =
            Mathf.PerlinNoise(
                _yNoiseSeed,
                Time.time * yNoiseSpeed
            ) * 2f - 1f;

        float xOffset =
            xNoise *
            Mathf.Abs(value) *
            xRandomAmount;

        float yOffset =
            yNoise *
            yRandomAmount;

        pos.x = _defaultX + xOffset;

        pos.y =
            _defaultY +
            (value * bobHeight) +
            yOffset;

        transform.localPosition = pos;
    }

    void ResetPosition()
    {
        Vector3 pos = transform.localPosition;

        pos.x = Mathf.Lerp(pos.x, _defaultX, Time.deltaTime * 5f);
        pos.y = Mathf.Lerp(pos.y, _defaultY, Time.deltaTime * 5f);

        transform.localPosition = pos;
    }
}