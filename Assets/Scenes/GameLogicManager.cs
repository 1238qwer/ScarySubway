using UnityEngine;
using UnityEngine.InputSystem;

public class GameLogicManager : MonoBehaviour
{

    [SerializeField] private Light[] _areaLigts;


    private LightManager _lightManager;
    // Start is called once before the first execution of Update after the MonoBehaviour is created

    private void Awake()
    {
        _lightManager = Object.FindAnyObjectByType<LightManager>();
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
            _lightManager.ToggleLights();
            _lightManager.ToggleDirectionalLight();
        }

        if (Keyboard.current.digit2Key.wasPressedThisFrame)
        {
            _lightManager.AnimateLights(1.5f, 3f);
        }
    }
}
