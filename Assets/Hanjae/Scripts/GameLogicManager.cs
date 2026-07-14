using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Rendering;

public class GameLogicManager : MonoBehaviour
{
    [System.Serializable]
    private class StageConfig
    {
        public int Stage = 0;
        [Range(0f, 1f)] public float AnomalyChance = 0.5f;
    }

    [SerializeField] private Volume _vignetteVolume;
    [SerializeField, Range(0f, 1f)] private float _blackoutVignetteWeight = 1f;
    [SerializeField] private HeadBob _headBob;
    [SerializeField] private float _normalDuration = 10f;
    [SerializeField] private float _resolveDuration = 10f;
    [SerializeField] private float _resolveStartDelay = 3f;
    [SerializeField] private StageConfig[] _stages;
    [SerializeField] private int _currentStageIndex;
    [SerializeField] private float _vignetteBlendDuration = 0.3f;

    private Coroutine _vignetteBlendCoroutine;

    private SoundManager _soundManager;
    private AnomalyManager _anomalyManager;
    private LightManager _lightManager;
    private UIManager _uiManager;
    private DirectionCameraManager _directionCameraManager;
    private ActorManager _actorManager;

    private float _stateElapsedTime;
    private float _resolveElapsedTime;

    private bool _isGameCleared;
    private bool _isInputLocked;
    private bool _isResolvePhaseActive;
    private bool _hasAnomalyThisStage;
    private bool _isResolveFinished;
    private bool _isStageTransitionHandled;

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
        _anomalyManager = Object.FindAnyObjectByType<AnomalyManager>();
        _uiManager = Object.FindAnyObjectByType<UIManager>();
        _directionCameraManager = Object.FindAnyObjectByType<DirectionCameraManager>();
        _actorManager = Object.FindAnyObjectByType<ActorManager>();

        if (_vignetteVolume != null)
            _vignetteVolume.gameObject.SetActive(false);
    }

    private void Start()
    {
        ClampStageIndex();
        SetVignetteWeight(0f);
        _directionCameraManager?.StartDirectionCamera();
        ResetRuntimeFlags();
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
        if (_isInputLocked)
            return;

        if (Keyboard.current.digit5Key.wasPressedThisFrame)
            ChangeState(GameState.Blackout);

        if (Keyboard.current.digit6Key.wasPressedThisFrame)
            ChangeState(GameState.Normal);

        if (Keyboard.current.digit7Key.wasPressedThisFrame)
            _anomalyManager?.TriggerRandomAnomaly();

        if (CurrentState != GameState.Blackout || !_isResolvePhaseActive)
            return;

        if (_isResolveFinished || _isStageTransitionHandled)
            return;

        // 우클릭: "이상현상 없음" 선택
        if (Mouse.current != null && (Keyboard.current.digit2Key.wasPressedThisFrame))
        {
            if (_hasAnomalyThisStage)
                HandleStageFailure();
            else
                HandleStageSuccess();

            return;
        }

        // 좌클릭: "이상현상 있음" 선택
        if (Mouse.current != null && (Keyboard.current.digit1Key.wasPressedThisFrame))
        {
            if (_hasAnomalyThisStage)
                HandleStageSuccess();
            else
                HandleStageFailure();
        }
    }

    private void ChangeState(GameState nextState)
    {
        if (CurrentState == nextState)
            return;

        ExitState(CurrentState);
        CurrentState = nextState;
        _stateElapsedTime = 0f;
        EnterState(CurrentState);
    }

    private void EnterState(GameState state)
    {
        switch (state)
        {
            case GameState.Normal:
                Debug.Log("Normal 상태 시작");
                EnterNormal();
                break;
            case GameState.Blackout:
                Debug.Log("Blackout 상태 시작");
                EnterBlackout();
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
        }
    }

    private void ExitState(GameState state)
    {
        switch (state)
        {
            case GameState.Normal:
                Debug.Log("Normal 상태 종료");
                break;
            case GameState.Blackout:
                Debug.Log("Blackout 상태 종료");
                break;
        }
    }

    private void EnterNormal()
    {
        SetVignetteWeight(0f);

        _headBob?.StopBob();
        _lightManager?.StopLights();
        _soundManager?.NormalAmbient();

        _uiManager?.SetResultUIActive(false);

        _anomalyManager?.InitializeAnomalyStates();

        _resolveElapsedTime = 0f;
        _isResolveFinished = false;
        _isStageTransitionHandled = false;
        _isResolvePhaseActive = false;
        _hasAnomalyThisStage = false;

        _actorManager?.ActivateRandomHalfActors();
    }

    private void UpdateNormal()
    {
        _stateElapsedTime += Time.deltaTime;
        if (_stateElapsedTime >= _normalDuration)
            ChangeState(GameState.Blackout);
    }

    private void EnterBlackout()
    {
        if (_vignetteVolume != null)
            _vignetteVolume.gameObject.SetActive(true);

        SetVignetteWeight(_blackoutVignetteWeight);

        _headBob?.StartBob();
        _lightManager?.StartLights();
        _soundManager?.PlayAnnouncement();
        _soundManager?.DistortionAmbient();

        _resolveElapsedTime = 0f;
        _isResolveFinished = false;
        _isStageTransitionHandled = false;
        _isResolvePhaseActive = false;

        _hasAnomalyThisStage = RollAnomalyForCurrentStage();
        _uiManager?.SetResultUIActive(false);
    }

    private void UpdateBlackout()
    {
        _stateElapsedTime += Time.deltaTime;

        if (!_isResolvePhaseActive)
        {
            if (_stateElapsedTime < _resolveStartDelay)
                return;

            _isResolvePhaseActive = true;
            _resolveElapsedTime = 0f;

            _uiManager?.SetResultUIActive(true);
            _uiManager?.SetResultSliderByTime(_resolveDuration, _resolveDuration);

            if (_hasAnomalyThisStage)
                TriggerAnomaly();
            else
                Debug.Log("[Anomaly] none");
        }

        if (_isResolveFinished)
            return;

        _resolveElapsedTime += Time.deltaTime;

        float remainingTime = Mathf.Max(0f, _resolveDuration - _resolveElapsedTime);
        _uiManager?.SetResultSliderByTime(remainingTime, _resolveDuration);

        if (_resolveElapsedTime < _resolveDuration)
            return;

        if (_hasAnomalyThisStage)
            HandleStageFailure();
        else
            HandleStageSuccess();
    }

    private void TriggerAnomaly()
    {
        bool triggered = _anomalyManager != null && _anomalyManager.TriggerRandomAnomaly();

        if (!triggered)
            _hasAnomalyThisStage = false;
    }

    private void HandleStageFailure()
    {
        _isResolveFinished = true;
        _isInputLocked = true;
        _uiManager?.StartFade("GO TO FIRST STATION..", ResetToFirstStage);
        Debug.Log("해결 실패: 첫 스테이지로 복귀");
    }

    private void HandleStageSuccess()
    {
        if (_isStageTransitionHandled)
            return;

        _isStageTransitionHandled = true;
        _isResolveFinished = true;
        _isInputLocked = true;

        if (IsLastStage())
        {
            _uiManager?.StartFade("CLEAR", () => { });
            _isGameCleared = true;
            Debug.Log("게임 클리어!");
            return;
        }

        int nextStageDisplay = GetNextStageDisplayNumber();
        int totalStages = GetTotalStageCount();
        string nextStationMessage = $"GO TO NEXT STATION... ({nextStageDisplay}/{totalStages})";

        _uiManager?.StartFade(nextStationMessage, MoveToNextStage);
        Debug.Log("다음 스테이지로 이동: " + nextStageDisplay + "/" + totalStages);
    }

    private void MoveToNextStage()
    {
        _isInputLocked = false;
        _currentStageIndex++;
        ChangeState(GameState.Normal);
    }

    private void ResetToFirstStage()
    {
        _isInputLocked = false;
        _currentStageIndex = 0;
        _isGameCleared = false;
        _directionCameraManager?.StartDirectionCamera();
        ChangeState(GameState.Normal);
    }

    private void ResetRuntimeFlags()
    {
        _stateElapsedTime = 0f;
        _resolveElapsedTime = 0f;
        _isResolveFinished = false;
        _isStageTransitionHandled = false;
        _isGameCleared = false;
        _isInputLocked = false;
        _isResolvePhaseActive = false;
        _hasAnomalyThisStage = false;
    }

    private bool RollAnomalyForCurrentStage()
    {
        if (_stages == null || _stages.Length == 0)
            return false;

        int index = Mathf.Clamp(_currentStageIndex, 0, _stages.Length - 1);
        float chance = Mathf.Clamp01(_stages[index].AnomalyChance);
        return Random.value <= chance;
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

    private void SetVignetteWeight(float weight)
    {
        if (_vignetteVolume == null)
            return;

        float targetWeight = Mathf.Clamp01(weight);

        if (_vignetteBlendCoroutine != null)
            StopCoroutine(_vignetteBlendCoroutine);

        if (!_vignetteVolume.gameObject.activeSelf)
            _vignetteVolume.gameObject.SetActive(true);

        _vignetteBlendCoroutine = StartCoroutine(BlendVignetteWeightRoutine(targetWeight));
    }

    private IEnumerator BlendVignetteWeightRoutine(float targetWeight)
    {
        float startWeight = _vignetteVolume.weight;
        float duration = Mathf.Max(0.01f, _vignetteBlendDuration);
        float elapsed = 0f;

        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            float t = Mathf.Clamp01(elapsed / duration);
            _vignetteVolume.weight = Mathf.Lerp(startWeight, targetWeight, t);
            yield return null;
        }

        _vignetteVolume.weight = targetWeight;

        if (targetWeight <= 0f)
            _vignetteVolume.gameObject.SetActive(false);

        _vignetteBlendCoroutine = null;
    }

    private int GetTotalStageCount()
    {
        return _stages != null && _stages.Length > 0 ? _stages.Length : 1;
    }

    private int GetNextStageDisplayNumber()
    {
        return Mathf.Clamp(_currentStageIndex + 2, 1, GetTotalStageCount());
    }
}