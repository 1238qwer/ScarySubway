using UnityEngine;
using static UnityEngine.Rendering.DebugUI;

public class LightManager : MonoBehaviour
{
    [SerializeField] private Light[] _defaultAreaLigts;
    [SerializeField] private Light[] _eventAreaLigts;

    [SerializeField] private Texture2D[] _dayLightmapColors;
    [SerializeField] private Texture2D[] _dayLightmapDirs;
    [SerializeField] private Texture2D[] _dayShadowMasks;

    [SerializeField] private Texture2D[] _nightLightmapColors;
    [SerializeField] private Texture2D[] _nightLightmapDirs;
    [SerializeField] private Texture2D[] _nightShadowMasks;

    [SerializeField] LightmapData[] _dayLightmaps;
    [SerializeField] LightmapData[] _nightLightmaps;

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

    private void Awake()
    {
        _dayLightmaps = BuildLightmaps(_dayLightmapColors, _dayLightmapDirs, _dayShadowMasks);
        _nightLightmaps = BuildLightmaps(_nightLightmapColors, _nightLightmapDirs, _nightShadowMasks);
    }

    void Update()
    {
        switch (CurrentState)
        {
            case LightState.Idle:
                ApplyAreaLightIntensity(0.15f);
                break;
            case LightState.Start:

                PlayStart();
                break;

            case LightState.Loop:
                ApplyNightLightmap();
                ApplyAreaLightColor(CurrentState);
                PlayLoop();
                break;

            case LightState.End:
                ApplyDayLightmap();
                ApplyAreaLightColor(CurrentState);
                PlayEnd();
                break;
        }
    }

    private LightmapData[] BuildLightmaps(Texture2D[] colors, Texture2D[] dirs, Texture2D[] masks)
    {
        if (colors == null || colors.Length == 0)
            return System.Array.Empty<LightmapData>();

        LightmapData[] result = new LightmapData[colors.Length];

        for (int i = 0; i < colors.Length; i++)
        {
            LightmapData data = new LightmapData();
            data.lightmapColor = colors[i];

            if (dirs != null && i < dirs.Length)
                data.lightmapDir = dirs[i];

            if (masks != null && i < masks.Length)
                data.shadowMask = masks[i];

            result[i] = data;
        }

        return result;
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

        ApplyAreaLightIntensity(area);
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

        ApplyAreaLightIntensity(area);
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

        ApplyAreaLightIntensity(area);
        ApplyDirectionalLight(dir);

        if (_timer >= endTime)
        {
            _timer = 0f;
            CurrentState = LightState.Idle;
        }
    }

    void ApplyAreaLightColor(LightState state)
    {
        foreach (var light in _defaultAreaLigts)
        {
            if (state == LightState.End)
            {
                light.color = _lightPreset.normalColor;
  
            }
            else if (state == LightState.Loop)
            {
                light.color = _lightPreset.directionColor;
            }

        }
    }

    void ApplyAreaLightIntensity(float value)
    {
        foreach (var light in _defaultAreaLigts)
        {
            light.intensity =
                value * _intensityMultiplier;
        }
    }

    void ApplyDirectionalLight(float value)
    {
        _directionalLight.intensity = value;
    }

    private void ApplyDayLightmap()
    {
        if (_dayLightmaps != null && _dayLightmaps.Length > 0)
            LightmapSettings.lightmaps = _dayLightmaps;
    }

    private void ApplyNightLightmap()
    {
        if (_nightLightmaps != null && _nightLightmaps.Length > 0)
            LightmapSettings.lightmaps = _nightLightmaps;
    }
}