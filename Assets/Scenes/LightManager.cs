using UnityEngine;

public class LightManager : MonoBehaviour
{
    [SerializeField] private Light[] _areaLigts;
    [SerializeField] private Light _directionalLight;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        AnimateLights(1.5f, 3f);
    }

    public void ToggleDirectionalLight()
    {
        _directionalLight.gameObject.SetActive(!_directionalLight.gameObject.activeSelf);
    }

    public void ToggleLights()
    {
        foreach (var light in _areaLigts)
        {
            light.gameObject.SetActive(!light.gameObject.activeSelf);
        }
    }

    public void AnimateLights(float minIntensity, float maxIntensity)
    {
        float range = maxIntensity - minIntensity;
        float pingPong = Mathf.PingPong(Time.time, 1);
        float intensity = minIntensity + pingPong * range;
        foreach (var light in _areaLigts)
        {
            light.intensity = intensity;
        }
    }
}
