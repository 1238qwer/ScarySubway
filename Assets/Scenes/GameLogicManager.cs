using UnityEngine;
using UnityEngine.InputSystem;

public class GameLogicManager : MonoBehaviour
{
    [SerializeField] private Light[] _areaLigts;
    [SerializeField] private HeadBob _headBob;

    private SoundManager _soundManager;
    private EventManager _eventManager;
    private LightManager _lightManager;

    [SerializeField] private float _stateInterval = 10f;

    private float _timer;

    public enum GameState
    {
        Normal,
        Blackout
    }

    public GameState CurrentState = GameState.Normal;

    private void Awake()
    {
        _lightManager = Object.FindAnyObjectByType<LightManager>();
        _soundManager = Object.FindAnyObjectByType<SoundManager>();
        _eventManager = Object.FindAnyObjectByType<EventManager>();
    }

    void Start()
    {
        //SetState(GameState.Normal);
    }

    void Update()
    {
        _timer += Time.deltaTime;

        if (_timer >= _stateInterval)
        {
            _timer = 0f;

            if (CurrentState == GameState.Normal)
            {
                SetState(GameState.Blackout);
            }
            else
            {
                SetState(GameState.Normal);
            }
        }

        if (Keyboard.current.digit1Key.wasPressedThisFrame)
        {
            _timer = 0f;
            SetState(GameState.Blackout);
        }

        if (Keyboard.current.digit2Key.wasPressedThisFrame)
        {
            _timer = 0f;
            SetState(GameState.Normal);
        }
    }

    void SetState(GameState state)
    {
        CurrentState = state;

        switch (CurrentState)
        {
            case GameState.Normal:
                ApplyNormalState();
                break;

            case GameState.Blackout:
                ApplyBlackoutState();
                break;
        }
    }

    void ApplyNormalState()
    {
        _headBob.StopBob();

        _lightManager.StopLights();

        _soundManager.NormalAmbient();
    }

    void ApplyBlackoutState()
    {
        _headBob.StartBob();

        _lightManager.StartLights();

        _soundManager.PlayAnnouncement();
        _soundManager.DistortionAmbient();
    }
}