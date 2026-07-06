using UnityEngine;
using System.Collections;
using UnityEngine.InputSystem;

public class DirectionCameraManager : MonoBehaviour
{
    [SerializeField] private Animator _animator;
    [SerializeField] private Camera _camera;
    [SerializeField] private PlayerInput _playerInput;

    private Coroutine _directionCoroutine;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        // 기본적으로 카메라는 꺼둠
        if (_camera != null)
            _camera.enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    // 카메라 켜고 애니메이터 재생, 재생이 완료되면 카메라 끔
    public void StartDirectionCamera()
    {
        // 이미 재생중이면 기존 코루틴 중지 후 재시작
        if (_directionCoroutine != null)
            StopCoroutine(_directionCoroutine);

        _directionCoroutine = StartCoroutine(PlayDirectionRoutine());
    }

    private IEnumerator PlayDirectionRoutine()
    {
        _playerInput.enabled = false; // 플레이어 입력 비활성화
        if (_camera != null)
            _camera.enabled = true;

        if (_animator == null)
        {
            // 애니메이터가 없으면 즉시 종료
            if (_camera != null)
                _camera.enabled = false;

            _directionCoroutine = null;
            yield break;
        }

        // 애니메이터 활성화 및 기본 레이어 0의 현재 상태를 처음부터 재생
        _animator.enabled = true;
        _animator.Play(0, 0, 0f);

        // 한 프레임 대기하여 상태 정보가 갱신되도록 함
        yield return null;

        // 애니메이션 재생이 끝날 때까지 대기
        // (현재 레이어 0의 상태가 전환중이거나 normalizedTime < 1이면 계속 대기)
        while (_animator.IsInTransition(0) || _animator.GetCurrentAnimatorStateInfo(0).normalizedTime < 1f)
        {
            yield return null;
        }

        // 재생 완료되면 카메라 끔
        if (_camera != null)
            _camera.enabled = false;

        _directionCoroutine = null;

        _playerInput.enabled = true; // 플레이어 입력 활성화
    }
}
