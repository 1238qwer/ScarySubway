using UnityEngine;

public class LightManager : MonoBehaviour
{
    [SerializeField] private Light[] _areaLigts;
    [SerializeField] private Light _directionalLight;
    [SerializeField] private LightPreset _lightPreset;
    [SerializeField] private float _intensityMultiplier = 1f;

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

        float endTime =
            _lightPreset.startCurve.keys[
                _lightPreset.startCurve.length - 1
            ].time;

        float area =
            _lightPreset.startCurve.Evaluate(_timer);

        float dir =
            _lightPreset.dirStartCurve.Evaluate(_timer);

        ApplyAreaLight(area);
        ApplyDirectionalLight(dir);

        if (_timer >= endTime)
        {
            _timer = 0f;
            CurrentState = LightState.Loop;
        }
    }

    void PlayLoop()
    {
        _timer += Time.deltaTime;

        float endTime =
            _lightPreset.loopCurve.keys[
                _lightPreset.loopCurve.length - 1
            ].time;

        float loopTime = _timer % endTime;

        float area =
            _lightPreset.loopCurve.Evaluate(loopTime);

        float dir =
            _lightPreset.dirLoopCurve.Evaluate(loopTime);

        ApplyAreaLight(area);
        ApplyDirectionalLight(dir);
    }

    void PlayEnd()
    {
        _timer += Time.deltaTime;

        float endTime =
            _lightPreset.endCurve.keys[
                _lightPreset.endCurve.length - 1
            ].time;

        float area =
            _lightPreset.endCurve.Evaluate(_timer);

        float dir =
            _lightPreset.dirEndCurve.Evaluate(_timer);

        ApplyAreaLight(area);
        ApplyDirectionalLight(dir);

        if (_timer >= endTime)
        {
            _timer = 0f;
            CurrentState = LightState.Idle;
        }
    }

    void ApplyAreaLight(float value)
    {
        foreach (var light in _areaLigts)
        {
            light.intensity =
                value * _intensityMultiplier;
        }
    }

    void ApplyDirectionalLight(float value)
    {
        _directionalLight.intensity = value;
    }
}