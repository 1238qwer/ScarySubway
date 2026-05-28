using UnityEngine;
using UnityEngine.InputSystem;

public class GameLogicManager : MonoBehaviour
{

    [SerializeField] private Light[] _areaLigts;
    [SerializeField] private HeadBob _headBob;
    SoundManager _soundManager;


    private LightManager _lightManager;
    // Start is called once before the first execution of Update after the MonoBehaviour is created

    private void Awake()
    {
        _lightManager = Object.FindAnyObjectByType<LightManager>();
            _soundManager = Object.FindAnyObjectByType<SoundManager>();
    }
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        //_lightManager.ToggleLights();
    }

    private void FixedUpdate()
    {
        //_lightManager.AnimateLights(1.5f, 3f);
    }

    // Update is called once per frame
    void Update()
    {
        if (Keyboard.current.digit1Key.wasPressedThisFrame)
        {
            //_lightManager.ToggleLights();
            //_lightManager.ToggleDirectionalLight();

            _headBob.StartBob();

            _lightManager.StartLights();

            _soundManager.PlayAnnouncement();
            _soundManager.DistortionAmbient();
        }

        if (Keyboard.current.digit2Key.wasPressedThisFrame)
        {
            _headBob.StopBob();
            _lightManager.StopLights();

            _soundManager.NormalAmbient();
        }
    }
}
