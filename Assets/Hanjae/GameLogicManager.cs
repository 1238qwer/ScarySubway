using UnityEngine;
using UnityEngine.InputSystem;

public class GameLogicManager : MonoBehaviour
{
    [System.Serializable]
    private class StageConfig
    {
        public int Stage = 0;
        [Min(0)] public int BlackoutEventCount = 3;
    }

    [SerializeField] private HeadBob _headBob;
    [SerializeField] private float _normalDuration = 10f;
    [SerializeField] private float _blackoutDuration = 20f;
    [SerializeField] private float _resultDuration = 10f;
    [SerializeField] private StageConfig[] _stages;
    [SerializeField] private int _currentStageIndex;
    [SerializeField] private PlayerCamera _playerCamera;

    private SoundManager _soundManager;
    private EventManager _eventManager;
    private LightManager _lightManager;
    private UIManager _ui_manager;
    private DirectionCameraManager _directionCameraManager;

    private float _stateTimer;
    private float _resultTimer;
    private bool _resultTimeoutHandled;
    private bool _nextStageLogged;
    private bool _isGameCleared;
    private bool _isInputLocked; // 입력 잠금 상태 추가

    private int _blackoutEventsTriggered;
    private int _blackoutEventCountForCurrentStage;
    private float _nextBlackoutEventTime;

    public enum GameState
    {
        Normal,
        Blackout,
        Result
    }

    public GameState CurrentState = GameState.Normal;

    private void Awake()
    {
        _lightManager = Object.FindAnyObjectByType<LightManager>();
        _soundManager = Object.FindAnyObjectByType<SoundManager>();
        _eventManager = Object.FindAnyObjectByType<EventManager>();
        _ui_manager = Object.FindAnyObjectByType<UIManager>();
        _directionCameraManager = Object.FindAnyObjectByType<DirectionCameraManager>();

        if (_playerCamera == null)
            _playerCamera = Object.FindAnyObjectByType<PlayerCamera>();
    }

    private void Start()
    {
        ClampStageIndex();
        _directionCameraManager?.StartDirectionCamera();
        ResetAllRuntimeFlags();
        EnterState(CurrentState);
    }

    private void Update()
    {
        if (_isGameCleared)
            return;

        HandleGlobalInput();
        UpdateState(CurrentState);
    }

    private void HandleGlobalInput()
    {
        if (_isInputLocked) // 입력이 잠겨있으면 반응하지 않음
            return;

        if (Keyboard.current.digit1Key.wasPressedThisFrame)
            ChangeState(GameState.Blackout);

        if (Keyboard.current.digit2Key.wasPressedThisFrame)
            ChangeState(GameState.Normal);

        if (Keyboard.current.digit3Key.wasPressedThisFrame)
            _eventManager?.ActorNeckRotateToPlayer();

        if (CurrentState != GameState.Result || _ui_manager == null || !_ui_manager.HasAnyEnabledEyes())
            return;

        if (_playerCamera == null || _eventManager == null)
            return;

        if (!Mouse.current.leftButton.wasPressedThisFrame)
            return;

        if (!_playerCamera.TryGetLookedActor(out Actor lookedActor))
            return;

        if (!_eventManager.WasBlackoutEventActor(lookedActor))
            return;

        if (_ui_manager.DisableFirstEnabledEye())
            TryHandleAllEyesDisabledInResult();
    }

    private void ChangeState(GameState nextState)
    {
        if (CurrentState == nextState)
            return;

        ExitState(CurrentState);
        CurrentState = nextState;
        _stateTimer = 0f;
        EnterState(CurrentState);
    }

    private void EnterState(GameState state)
    {
        switch (state)
        {
            case GameState.Normal:
                EnterNormal();
                break;
            case GameState.Blackout:
                EnterBlackout();
                break;
            case GameState.Result:
                EnterResult();
                break;
        }
    }

    private void UpdateState(GameState state)
    {
        switch (state)
        {
            case GameState.Normal:
                UpdateNormal();
                break;
            case GameState.Blackout:
                UpdateBlackout();
                break;
            case GameState.Result:
                UpdateResult();
                break;
        }
    }

    private void ExitState(GameState state)
    {
        switch (state)
        {
            case GameState.Normal:
                ExitNormal();
                break;
            case GameState.Blackout:
                ExitBlackout();
                break;
            case GameState.Result:
                ExitResult();
                break;
        }
    }

    private void EnterNormal()
    {
        _headBob?.StopBob();
        _lightManager?.StopLights();
        _soundManager?.NormalAmbient();
        _ui_manager?.ResetEyes();
        _ui_manager?.SetResultUIActive(false);
        _eventManager?.ClearBlackoutEventActors();
    }

    private void UpdateNormal()
    {
        _stateTimer += Time.deltaTime;
        if (_stateTimer >= _normalDuration)
            ChangeState(GameState.Blackout);
    }

    private void ExitNormal()
    {
        Debug.Log("Normal 상태 종료");
    }

    private void EnterBlackout()
    {
        _headBob?.StartBob();
        _lightManager?.StartLights();
        _soundManager?.PlayAnnouncement();
        _soundManager?.DistortionAmbient();
        _ui_manager?.SetResultUIActive(false);

        _eventManager?.ClearBlackoutEventActors();

        _blackoutEventsTriggered = 0;
        _blackoutEventCountForCurrentStage = GetCurrentStageBlackoutEventCount();
        _nextBlackoutEventTime = _blackoutEventCountForCurrentStage > 0
            ? GetBlackoutEventStep()
            : float.MaxValue;
    }

    private void UpdateBlackout()
    {
        _stateTimer += Time.deltaTime;

        if (_stateTimer >= _blackoutDuration)
        {
            ChangeState(GameState.Result);
            return;
        }

        if (_blackoutEventsTriggered >= _blackoutEventCountForCurrentStage)
            return;

        float step = GetBlackoutEventStep();
        while (_blackoutEventsTriggered < _blackoutEventCountForCurrentStage && _stateTimer >= _nextBlackoutEventTime)
        {
            TriggerBlackoutEvent();
            _blackoutEventsTriggered++;
            _nextBlackoutEventTime += step;

            if (CurrentState != GameState.Blackout)
                return;
        }
    }

    private void TriggerBlackoutEvent()
    {
        _ui_manager?.EnableNextEyeIcon();

        if (_ui_manager != null && _ui_manager.WasFullyEnabled)
        {
            ChangeState(GameState.Result);
            return;
        }

        int randInt = Random.Range(0, 3);
        if (randInt == 0)
        {
            _eventManager?.ActorJumpSquare();
            _soundManager?.PlayJumpsquareSound();
        }
        else
        {
            _eventManager?.ActorNeckRotateToPlayer();
        }
    }

    private void ExitBlackout()
    {
        Debug.Log("Blackout 상태 종료");
        _eventManager?.ClearBlackoutEventActors();
    }

    private void EnterResult()
    {
        _headBob?.StopBob();
        _lightManager?.StopLights();
        _soundManager?.NormalAmbient();
        _resultTimer = 0f;
        _resultTimeoutHandled = false;
        _nextStageLogged = false;

        _ui_manager?.SetResultUIActive(true);
        _ui_manager?.SetResultSliderByTime(_resultDuration, _resultDuration);
    }

    private void UpdateResult()
    {
        if (_resultTimeoutHandled)
            return;

        if (_ui_manager != null && _ui_manager.AreAllEyesDisabled())
            return;

        _resultTimer += Time.deltaTime;

        float remainingTime = Mathf.Max(0f, _resultDuration - _resultTimer);
        _ui_manager?.SetResultSliderByTime(remainingTime, _resultDuration);

        if (_resultTimer >= _resultDuration)
            HandleResultTimeout();
    }

    private void ExitResult()
    {
        Debug.Log("Result 상태 종료");
    }

    private void HandleResultTimeout()
    {
        _resultTimeoutHandled = true;
        _isInputLocked = true;

        if (_ui_manager != null)
            _ui_manager.StartFade("GO TO FIRST STATION..", ResetToFirstState);

        Debug.Log("Result 타임아웃: 첫 상태로 복귀");
    }

    private void TryHandleAllEyesDisabledInResult()
    {
        if (_nextStageLogged)
            return;

        if (_ui_manager == null || !_ui_manager.AreAllEyesDisabled())
            return;

        _nextStageLogged = true;
        _resultTimeoutHandled = true;

        if (IsLastStage())
        {
            _ui_manager.StartFade("CLEAR", () => { });
            _isGameCleared = true;
            Debug.Log("게임 클리어!");
            return;
        }
        else
        {
            _ui_manager.StartFade("GO TO NEXT STATION...", MoveToNextStage);
        }

        Debug.Log("다음스테이지로");
    }

    private void MoveToNextStage()
    {
        _isInputLocked = false;
        _currentStageIndex++;
        ChangeState(GameState.Normal);
        _resultTimer = 0f;
        _resultTimeoutHandled = false;
    }

    private void ResetToFirstState()
    {
        _isInputLocked = false;
        _currentStageIndex = 0;
        _isGameCleared = false;
        _ui_manager?.ResetEyes();
        _resultTimer = 0f;
        _resultTimeoutHandled = false;
        _nextStageLogged = false;
        _directionCameraManager?.StartDirectionCamera();
        ChangeState(GameState.Normal);
    }

    private void ResetAllRuntimeFlags()
    {
        _stateTimer = 0f;
        _resultTimer = 0f;
        _resultTimeoutHandled = false;
        _nextStageLogged = false;
        _isGameCleared = false;
        _isInputLocked = false;
        _blackoutEventsTriggered = 0;
        _blackoutEventCountForCurrentStage = 0;
        _nextBlackoutEventTime = float.MaxValue;
    }

    private int GetCurrentStageBlackoutEventCount()
    {
        if (_stages == null || _stages.Length == 0)
            return 0;

        int index = Mathf.Clamp(_currentStageIndex, 0, _stages.Length - 1);
        return Mathf.Max(0, _stages[index].BlackoutEventCount);
    }

    private float GetBlackoutEventStep()
    {
        if (_blackoutEventCountForCurrentStage <= 0)
            return float.MaxValue;

        float safeDuration = Mathf.Max(0.01f, _blackoutDuration);
        return safeDuration / (_blackoutEventCountForCurrentStage + 1f);
    }

    private bool IsLastStage()
    {
        if (_stages == null || _stages.Length == 0)
            return true;

        return _currentStageIndex >= _stages.Length - 1;
    }

    private void ClampStageIndex()
    {
        if (_stages == null || _stages.Length == 0)
        {
            _currentStageIndex = 0;
            return;
        }

        _currentStageIndex = Mathf.Clamp(_currentStageIndex, 0, _stages.Length - 1);
    }
}