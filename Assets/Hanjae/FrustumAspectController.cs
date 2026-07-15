using UnityEngine;

[RequireComponent(typeof(Camera))]
public class FrustumAspectController : MonoBehaviour
{
    [SerializeField] private int _targetWidth = 9;
    [SerializeField] private int _targetHeight = 16;
    [SerializeField] private Color _barColor = Color.black;

    private Camera _camera;
    private int _lastScreenWidth;
    private int _lastScreenHeight;

    private void Awake()
    {
        _camera = GetComponent<Camera>();
    }

    private void OnEnable()
    {
        ApplyAspect();
    }

    private void Start()
    {
        ApplyAspect();
    }

    private void LateUpdate()
    {
        if (_lastScreenWidth == Screen.width && _lastScreenHeight == Screen.height)
            return;

        ApplyAspect();
    }

    private void ApplyAspect()
    {
        _lastScreenWidth = Screen.width;
        _lastScreenHeight = Screen.height;

        if (_camera == null || _targetWidth <= 0 || _targetHeight <= 0)
            return;

        float targetAspect = (float)_targetWidth / _targetHeight;
        float windowAspect = (float)Screen.width / Screen.height;
        float scaleHeight = windowAspect / targetAspect;

        if (scaleHeight < 1f)
        {
            Rect rect = _camera.rect;
            rect.width = 1f;
            rect.height = scaleHeight;
            rect.x = 0f;
            rect.y = (1f - scaleHeight) * 0.5f;
            _camera.rect = rect;
        }
        else
        {
            float scaleWidth = 1f / scaleHeight;

            Rect rect = _camera.rect;
            rect.width = scaleWidth;
            rect.height = 1f;
            rect.x = (1f - scaleWidth) * 0.5f;
            rect.y = 0f;
            _camera.rect = rect;
        }
    }

    private void OnPreCull()
    {
        GL.Clear(true, true, _barColor);
    }
}