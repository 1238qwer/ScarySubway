using UnityEngine;
using UnityEngine.InputSystem;

public class GameLogicManager : MonoBehaviour
{
    [SerializeField] private HeadBob _headBob;

    private SoundManager _soundManager;
    private EventManager _eventManager;
    private LightManager _lightManager;
    private UIManager _ui_manager;
    private DirectionCameraManager _directionCameraManager;

    [SerializeField] private float _blackoutEventInterval = 5f;

    // 상태 지속 시간 (초)
    [SerializeField] private float _normalDuration = 20f;
    [SerializeField] private float _blackoutDuration = 20f;
    [SerializeField] private float _resultDuration = 10f; // Result에서 허용되는 시간

    private float _blackoutEventTimer;
    private float _stateTimer;

    // Result 상태에서 "다음스테이지로" 로그가 여러번 찍히지 않도록 기록
    private bool _nextStageLogged = false;

    // Result 타임아웃 처리 플래그/타이머
    private float _resultTimer = 0f;
    private bool _resultTimeoutHandled = false;

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
    }

    private void Start()
    {
        _directionCameraManager?.StartDirectionCamera();
        _stateTimer = 0f;
        _blackoutEventTimer = 0f;
        _resultTimer = 0f;
        _resultTimeoutHandled = false;
    }

    void Update()
    {
        UpdateStateTimer();
        UpdateBlackoutEvents();
        UpdateResultTimer();
        HandleInput();
    }

    void UpdateStateTimer()
    {
        if (CurrentState == GameState.Result)
            return;

        _stateTimer += Time.deltaTime;

        switch (CurrentState)
        {
            case GameState.Normal:
                if (_stateTimer >= _normalDuration)
                    SetState(GameState.Blackout);
                break;

            case GameState.Blackout:
                if (_stateTimer >= _blackoutDuration)
                    SetState(GameState.Result);
                break;
        }
    }

    void UpdateBlackoutEvents()
    {
        if (CurrentState != GameState.Blackout)
            return;

        _blackoutEventTimer += Time.deltaTime;

        if (_blackoutEventTimer < _blackoutEventInterval)
            return;

        _blackoutEventTimer = 0f;

        if (_ui_manager != null)
            _ui_manager.EnableNextEyeIcon();

        if (_ui_manager != null && _ui_manager.WasFullyEnabled)
        {
            SetState(GameState.Result);
            return;
        }

        int randInt = UnityEngine.Random.Range(0, 3);

        if (randInt == 0)
        {
            _eventManager.ActorJumpSquare();
            _soundManager.PlayJumpsquareSound();
        }
        else
        {
            _eventManager.ActorNeckRotateToPlayer();
        }
    }

    // Result 상태에서 플레이어가 시간 내에 모든 눈을 끄지 못했는지 검사
    void UpdateResultTimer()
    {
        if (CurrentState != GameState.Result)
            return;

        // 이미 타임아웃 처리되었으면 더 이상 검사하지 않음
        if (_resultTimeoutHandled)
            return;

        // 플레이어가 이미 모든 눈을 끄고 정상으로 돌아간 경우(다른 로직에서 처리되었을 것)
        if (_ui_manager != null && _ui_manager.AreAllEyesDisabled())
            return;

        _resultTimer += Time.deltaTime;

        if (_resultTimer >= _resultDuration)
        {
            HandleResultTimeout();
        }
    }

    void HandleResultTimeout()
    {
        _resultTimeoutHandled = true;

        // 페이드로 알림
        if (_ui_manager != null)
            _ui_manager.StartFade("GO TO FIRST STATION..", ResetToFirstState);
        Debug.Log("Result 타임아웃: 첫 상태로 복귀");

        // 모든 게임정보 초기화 및 첫 상태부터 다시 시작
        ResetToFirstState();
    }

    void HandleInput()
    {
        if (Keyboard.current.digit1Key.wasPressedThisFrame)
            SetState(GameState.Blackout);

        if (Keyboard.current.digit2Key.wasPressedThisFrame)
            SetState(GameState.Normal);

        if (Keyboard.current.digit3Key.wasPressedThisFrame)
            _eventManager.ActorNeckRotateToPlayer();

        // Result 상태에서 Q/W/E로 눈을 끌 때 모든 눈이 꺼지면 디버그 출력
        if (CurrentState == GameState.Result && _ui_manager != null && _ui_manager.WasFullyEnabled)
        {
            if (Keyboard.current.qKey.wasPressedThisFrame)
            {
                _ui_manager.DisableEyeAtIndex(0);
                CheckAllEyesOffAndLog();
            }

            if (Keyboard.current.wKey.wasPressedThisFrame)
            {
                _ui_manager.DisableEyeAtIndex(1);
                CheckAllEyesOffAndLog();
            }

            if (Keyboard.current.eKey.wasPressedThisFrame)
            {
                _ui_manager.DisableEyeAtIndex(2);
                CheckAllEyesOffAndLog();
            }
        }
    }

    private void CheckAllEyesOffAndLog()
    {
        if (_nextStageLogged)
            return;

        if (_ui_manager != null && _ui_manager.AreAllEyesDisabled())
        {
            _ui_manager.StartFade("GO TO NEXT STATION...");
            Debug.Log("다음스테이지로");

            // 다음 스테이지 준비: Normal 상태로 돌리기 전에 UI 상태 초기화
            SetState(GameState.Normal);
            _nextStageLogged = true;
        }
    }

    // 모든 게임정보 초기화 및 DirectionCameraManager.StartDirectionCamera()부터 시작
    private void ResetToFirstState()
    {
        // UI 리셋
        _ui_manager?.ResetEyes();

        // 상태와 타이머 리셋
        _resultTimer = 0f;
        _resultTimeoutHandled = false;
        _nextStageLogged = false;

        // 기타 매니저 초기화 가능한 항목들(있다면 호출)
        _headBob?.StopBob();
        _lightManager?.StopLights();
        _soundManager?.NormalAmbient();

        // 첫 연출 재생(카메라) 및 상태를 Normal로 설정
        _directionCameraManager?.StartDirectionCamera();
        SetState(GameState.Normal);
    }

    void SetState(GameState state)
    {
        if (CurrentState == state)
            return;

        CurrentState = state;

        _stateTimer = 0f;
        _blackoutEventTimer = 0f;

        // Result 진입 시 로그 플래그 초기화 및 타이머 초기화
        if (CurrentState == GameState.Result)
        {
            _nextStageLogged = false;
            _resultTimer = 0f;
            _resultTimeoutHandled = false;
        }

        switch (CurrentState)
        {
            case GameState.Normal:
                ApplyNormalState();
                break;

            case GameState.Blackout:
                ApplyBlackoutState();
                break;

            case GameState.Result:
                ApplyResultState();
                break;
        }
    }

    void ApplyNormalState()
    {
        _headBob.StopBob();
        _lightManager.StopLights();
        _soundManager.NormalAmbient();

        // 새 사이클을 위해 UI의 눈 상태와 플래그를 리셋
        _ui_manager?.ResetEyes();
    }

    void ApplyBlackoutState()
    {
        _headBob.StartBob();
        _lightManager.StartLights();
        _soundManager.PlayAnnouncement();
        _soundManager.DistortionAmbient();
    }

    void ApplyResultState()
    {
        _headBob.StopBob();
        _lightManager.StopLights();
        _soundManager.NormalAmbient();

        // Result 상태 진입 시 타이머 초기화
        _resultTimer = 0f;
        _resultTimeoutHandled = false;
    }
}