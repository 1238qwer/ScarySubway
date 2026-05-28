using UnityEngine;

public class LightManager : MonoBehaviour
{
    [SerializeField] private Light[] _areaLigts;
    [SerializeField] private Light _directionalLight;

    [SerializeField] private LightPreset _lightPreset;


    [SerializeField] private float _intensityMultiplier = 1f;


    [SerializeField] private float _startDuration = 1f;
    [SerializeField] private float _loopDuration = 2f;
    [SerializeField] private float _endDuration = 1f;

    private float _timer;

    public enum LightState
    {
        Idle,
        Start,
        Loop,
        End
    }

    public LightState CurrentState = LightState.Idle;

    void Update()
    {
        switch (CurrentState)
        {
            case LightState.Start:
                PlayStart();
                break;

            case LightState.Loop:
                PlayLoop();
                break;

            case LightState.End:
                PlayEnd();
                break;
        }
    }

    public void StartLights()
    {
        _timer = 0f;
        CurrentState = LightState.Start;
    }

    public void StopLights()
    {
        _timer = 0f;
        CurrentState = LightState.End;
    }

    void PlayStart()
    {
        _timer += Time.deltaTime;

        float t = _timer / _startDuration;

        float area = _lightPreset.startCurve.Evaluate(t);
        float dir = _lightPreset.dirStartCurve.Evaluate(t);

        ApplyAreaLight(area);
        ApplyDirectionalLight(dir);

        if (_lightPreset.startCurve.keys[_lightPreset.startCurve.length - 1].time <= t)
        {
            _timer = 0f;
            CurrentState = LightState.Loop;
        }
    }

    void PlayLoop()
    {
        _timer += Time.deltaTime;

        float t = (_timer % _loopDuration) / _loopDuration;

        float area = _lightPreset.loopCurve.Evaluate(t);
        float dir = _lightPreset.dirLoopCurve.Evaluate(t);

        ApplyAreaLight(area);
        ApplyDirectionalLight(dir);
    }

    void PlayEnd()
    {
        _timer += Time.deltaTime;

        float t = _timer / _endDuration;

        float area = _lightPreset.endCurve.Evaluate(t);
        float dir = _lightPreset.dirEndCurve.Evaluate(t);

        ApplyAreaLight(area);
        ApplyDirectionalLight(dir);

        if (_lightPreset.endCurve.keys[_lightPreset.endCurve.length - 1].time <= t)
        {
            _timer = 0f;
            CurrentState = LightState.Idle;
        }
    }

    void ApplyAreaLight(float value)
    {
        foreach (var light in _areaLigts)
        {
            light.intensity = value * _intensityMultiplier;
        }
    }

    void ApplyDirectionalLight(float value)
    {
        _directionalLight.intensity = value;
    }
}