using UnityEngine;
using UnityEngine.InputSystem;

public class GameLogicManager : MonoBehaviour
{
    [SerializeField] private HeadBob _headBob;

    private SoundManager _soundManager;
    private EventManager _eventManager;
    private LightManager _lightManager;

    [SerializeField] private float _stateInterval = 10f;
    [SerializeField] private float _blackoutEventInterval = 5f;

    private float _stateTimer;
    private float _blackoutEventTimer;

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

    void Update()
    {
        UpdateStateLoop();

        UpdateBlackoutEvents();

        HandleInput();
    }

    void UpdateStateLoop()
    {
        _stateTimer += Time.deltaTime;

        if (_stateTimer < _stateInterval)
            return;

        _stateTimer = 0f;

        ToggleState();
    }

    void UpdateBlackoutEvents()
    {
        if (CurrentState != GameState.Blackout)
            return;

        _blackoutEventTimer += Time.deltaTime;

        if (_blackoutEventTimer < _blackoutEventInterval)
            return;

        _blackoutEventTimer = 0f;

        int randInt = UnityEngine.Random.Range(0, 2);  

        if (randInt == 0)
        {
            _eventManager.ActorNeckRotateToPlayer();
        }
        else
        {
            _eventManager.ActorJumpSquare();
            _soundManager.PlayJumpsquareSound();
        }

    }

    void HandleInput()
    {
        if (Keyboard.current.digit1Key.wasPressedThisFrame)
        {
            _stateTimer = 0f;

            SetState(GameState.Blackout);
        }

        if (Keyboard.current.digit2Key.wasPressedThisFrame)
        {
            _stateTimer = 0f;

            SetState(GameState.Normal);
        }

        if (Keyboard.current.digit3Key.wasPressedThisFrame)
        {
            _eventManager.ActorNeckRotateToPlayer();
        }
    }

    void ToggleState()
    {
        switch (CurrentState)
        {
            case GameState.Normal:
                SetState(GameState.Blackout);
                break;

            case GameState.Blackout:
                SetState(GameState.Normal);
                break;
        }
    }

    void SetState(GameState state)
    {
        CurrentState = state;

        _blackoutEventTimer = 0f;

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