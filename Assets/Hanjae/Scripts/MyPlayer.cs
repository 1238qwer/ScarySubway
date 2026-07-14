using UnityEngine;
using UnityEngine.InputSystem;
using Unity.Cinemachine;

public class MyPlayer : MonoBehaviour
{
    [Header("Body Tilt (QAD)")]
    [SerializeField] private float _forwardTiltX = 8f;
    [SerializeField] private float _sideTiltZ = 10f;
    [SerializeField] private float _lerpSpeed = 8f;

    [Header("Zoom (W)")]
    [SerializeField] private float _zoomFov = 40f;
    [SerializeField] private float _zoomLerpSpeed = 10f;

    [Header("Frustum Control (Arrow Keys)")]
    [SerializeField] private Transform _cameraTransform;
    [SerializeField] private float _frustumYawSpeed = 90f;
    [SerializeField] private float _frustumPitchSpeed = 70f;
    [SerializeField] private float _maxFrustumYaw = 25f;
    [SerializeField] private float _maxFrustumPitch = 15f;

    private float _currentTiltX;
    private float _currentTiltZ;
    private Quaternion _baseLocalRotation;

    private float _frustumYaw;
    private float _frustumPitch;
    private Quaternion _cameraBaseLocalRotation;

    [SerializeField] private CinemachineVirtualCamera _camera;
    private float _defaultFov;

    private void Start()
    {
        _baseLocalRotation = transform.localRotation;

        if (_cameraTransform == null && Camera.main != null)
            _cameraTransform = Camera.main.transform;

        if (_cameraTransform != null)
            _cameraBaseLocalRotation = _cameraTransform.localRotation;

        //_camera = _cameraTransform != null ? _cameraTransform.GetComponent<Camera>() : null;
        //if (_camera == null)
        //    _camera = Camera.main;

        if (_camera != null)
            _defaultFov = _camera.m_Lens.FieldOfView;
    }

    private void Update()
    {
        if (Keyboard.current == null)
            return;

        UpdateBodyTilt();
        UpdateFrustumByArrowKeys();
        UpdateZoomByWKey();
    }

    private void UpdateBodyTilt()
    {
        float targetX = Keyboard.current.qKey.isPressed ? _forwardTiltX : 0f;

        float targetZ = 0f;
        if (Keyboard.current.leftArrowKey.isPressed)
            targetZ = _sideTiltZ;
        else if (Keyboard.current.rightArrowKey.isPressed)
            targetZ = -_sideTiltZ;

        float t = _lerpSpeed * Time.deltaTime;
        _currentTiltX = Mathf.Lerp(_currentTiltX, targetX, t);
        _currentTiltZ = Mathf.Lerp(_currentTiltZ, targetZ, t);

        transform.localRotation = _baseLocalRotation * Quaternion.Euler(_currentTiltX, 0f, _currentTiltZ);
    }

    private void UpdateFrustumByArrowKeys()
    {
        if (_cameraTransform == null)
            return;

        float yawInput = 0f;
        if (Keyboard.current.aKey.isPressed)
            yawInput -= 1f;
        if (Keyboard.current.dKey.isPressed)
            yawInput += 1f;

        float pitchInput = 0f;
        if (Keyboard.current.wKey.isPressed)
            pitchInput += 1f;
        if (Keyboard.current.sKey.isPressed)
            pitchInput -= 1f;

        _frustumYaw += yawInput * _frustumYawSpeed * Time.deltaTime;
        _frustumPitch += pitchInput * _frustumPitchSpeed * Time.deltaTime;

        _frustumYaw = Mathf.Clamp(_frustumYaw, -_maxFrustumYaw, _maxFrustumYaw);
        _frustumPitch = Mathf.Clamp(_frustumPitch, -_maxFrustumPitch, _maxFrustumPitch);

        _cameraTransform.localRotation =
            _cameraBaseLocalRotation * Quaternion.Euler(-_frustumPitch, _frustumYaw, 0f);
    }

    private void UpdateZoomByWKey()
    {
        if (_camera == null)
            return;

        float targetFov = Keyboard.current.spaceKey.isPressed ? _zoomFov : _defaultFov;
        float t = _zoomLerpSpeed * Time.deltaTime;
        _camera.m_Lens.FieldOfView = Mathf.Lerp(_camera.m_Lens.FieldOfView, targetFov, t);
    }
}
