using UnityEngine;
using UnityEngine.InputSystem;

public class MyPlayer : MonoBehaviour
{
    [SerializeField] private float _forwardTiltX = 8f;
    [SerializeField] private float _sideTiltZ = 10f;
    [SerializeField] private float _lerpSpeed = 8f;

    private float _currentTiltX;
    private float _currentTiltZ;
    private Quaternion _baseLocalRotation;

    private void Start()
    {
        _baseLocalRotation = transform.localRotation;
    }

    private void Update()
    {
        if (Keyboard.current == null)
            return;

        float targetX = Keyboard.current.wKey.isPressed ? _forwardTiltX : 0f;

        float targetZ = 0f;
        if (Keyboard.current.aKey.isPressed)
            targetZ = _sideTiltZ;
        else if (Keyboard.current.dKey.isPressed)
            targetZ = -_sideTiltZ;

        float t = _lerpSpeed * Time.deltaTime;
        _currentTiltX = Mathf.Lerp(_currentTiltX, targetX, t);
        _currentTiltZ = Mathf.Lerp(_currentTiltZ, targetZ, t);

        transform.localRotation = _baseLocalRotation * Quaternion.Euler(_currentTiltX, 0f, _currentTiltZ);
    }
}
