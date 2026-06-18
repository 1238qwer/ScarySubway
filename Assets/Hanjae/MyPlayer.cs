using UnityEngine;
using UnityEngine.InputSystem;

public class MyPlayer : MonoBehaviour
{
    [SerializeField] private float _peekMoveZ = 0.15f;
    [SerializeField] private float _peekRotateX = 8f;
    [SerializeField] private float _lerpSpeed = 8f;

    private float _currentPeekZ;
    private float _currentPeekXAngle;

    private float _appliedPeekZ;
    private float _appliedPeekXAngle;

    private void Update()
    {
        bool isPeeking = Keyboard.current != null && Keyboard.current.wKey.isPressed;

        float targetZ = isPeeking ? _peekMoveZ : 0f;
        float targetXAngle = isPeeking ? _peekRotateX : 0f;

        float t = _lerpSpeed * Time.deltaTime;
        _currentPeekZ = Mathf.Lerp(_currentPeekZ, targetZ, t);
        _currentPeekXAngle = Mathf.Lerp(_currentPeekXAngle, targetXAngle, t);

        float deltaZ = _currentPeekZ - _appliedPeekZ;
        float deltaXAngle = _currentPeekXAngle - _appliedPeekXAngle;

        Vector3 pos = transform.localPosition;
        pos.z += deltaZ;
        transform.localPosition = pos;

        transform.localRotation = transform.localRotation * Quaternion.Euler(deltaXAngle, 0f, 0f);

        _appliedPeekZ = _currentPeekZ;
        _appliedPeekXAngle = _currentPeekXAngle;
    }
}
