using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UIManager : MonoBehaviour
{
    [SerializeField] private GameObject _eyesIconPos;
    [SerializeField] private Texture _eyeIconTexture;
    [SerializeField] private Vector2 _eyeIconSize = new Vector2(80f, 80f);
    [SerializeField] private int _eyeIconCount = 3;
    [SerializeField] private float _eyeIconSpacing = 150f;

    [SerializeField] private Canvas _fadeCanvas;
    [SerializeField] private Image _fadeImg;
    [SerializeField] private TextMeshProUGUI _fadeText;

    [SerializeField] private GameObject _resultUIObject;
    [SerializeField] private Slider _resultSlider;

    private RawImage[] _eyesIcons;
    private int _nextEyeIndex = 0;

    public bool WasFullyEnabled { get; private set; } = false;
    private Coroutine _fadeCoroutine;

    private void Start()
    {
        CreateEyeIcons(_eyeIconCount);

        if (_fadeCanvas != null)
            _fadeCanvas.gameObject.SetActive(true);

        if (_fadeImg != null)
            _fadeImg.gameObject.SetActive(false);

        if (_fadeText != null)
            _fadeText.gameObject.SetActive(false);

        SetResultUIActive(false);
        SetResultSliderByTime(0f, 1f);
    }

    public void SetResultUIActive(bool isActive)
    {
        if (_resultUIObject != null)
            _resultUIObject.SetActive(isActive);
    }

    public void SetResultSliderByTime(float remainingTime, float totalTime)
    {
        if (_resultSlider == null)
            return;

        float normalized = totalTime <= 0f
            ? 0f
            : Mathf.Clamp01(remainingTime / totalTime);

        _resultSlider.minValue = 0f;
        _resultSlider.maxValue = 1f;
        _resultSlider.value = normalized;
    }

    public void EnsureEyeIconCapacity(int requiredCount)
    {
        int safeCount = Mathf.Max(0, requiredCount);

        if (_eyesIcons != null && _eyesIcons.Length == safeCount)
        {
            ResetEyes();
            return;
        }

        CreateEyeIcons(safeCount);
    }

    private void CreateEyeIcons(int count)
    {
        if (_eyesIconPos == null || _eyeIconTexture == null || count < 0)
        {
            _eyesIcons = Array.Empty<RawImage>();
            _nextEyeIndex = 0;
            WasFullyEnabled = false;
            return;
        }

        Transform parent = _eyesIconPos.transform;

        for (int i = parent.childCount - 1; i >= 0; i--)
            Destroy(parent.GetChild(i).gameObject);

        _eyesIcons = new RawImage[count];

        float startX = -_eyeIconSpacing * (count - 1) * 0.5f;

        for (int i = 0; i < count; i++)
        {
            GameObject iconObject = new GameObject($"EyeIcon_{i}", typeof(RectTransform), typeof(CanvasRenderer), typeof(RawImage));
            iconObject.transform.SetParent(parent, false);

            RawImage icon = iconObject.GetComponent<RawImage>();
            icon.texture = _eyeIconTexture;

            RectTransform rect = icon.rectTransform;
            rect.sizeDelta = _eyeIconSize;
            rect.anchoredPosition3D = new Vector3(startX + (_eyeIconSpacing * i), 0f, 0f);

            iconObject.SetActive(false);
            _eyesIcons[i] = icon;
        }

        _eyeIconCount = count;
        _nextEyeIndex = 0;
        WasFullyEnabled = false;
    }

    public void EnableNextEyeIcon()
    {
        if (_eyesIcons == null || _nextEyeIndex >= _eyesIcons.Length)
            return;

        RawImage icon = _eyesIcons[_nextEyeIndex];
        if (icon != null)
            icon.gameObject.SetActive(true);

        _nextEyeIndex++;

        if (_nextEyeIndex >= _eyesIcons.Length)
            WasFullyEnabled = true;
    }

    public void DisableEyeAtIndex(int index)
    {
        if (_eyesIcons == null)
            return;

        if (index < 0 || index >= _eyesIcons.Length)
            return;

        RawImage icon = _eyesIcons[index];
        if (icon != null)
            icon.gameObject.SetActive(false);

        if (index < _nextEyeIndex)
            _nextEyeIndex = index;
    }

    public bool DisableFirstEnabledEye()
    {
        if (_eyesIcons == null || _eyesIcons.Length == 0)
            return false;

        for (int i = 0; i < _eyesIcons.Length; i++)
        {
            if (_eyesIcons[i] != null && _eyesIcons[i].gameObject.activeSelf)
            {
                _eyesIcons[i].gameObject.SetActive(false);

                if (i < _nextEyeIndex)
                    _nextEyeIndex = i;

                return true;
            }
        }

        return false;
    }

    private void RearrangeActiveEyes()
    {
        if (_eyesIcons == null || _eyesIcons.Length == 0)
            return;

        List<RawImage> activeEyes = new List<RawImage>();
        for (int i = 0; i < _eyesIcons.Length; i++)
        {
            if (_eyesIcons[i] != null && _eyesIcons[i].gameObject.activeSelf)
                activeEyes.Add(_eyesIcons[i]);
        }

        int count = activeEyes.Count;
        if (count == 0)
            return;

        float[] xPositions = GetXPositions(count);

        for (int i = 0; i < count; i++)
            SetIconLocalPosition(activeEyes[i], xPositions[i], 0f, 0f);
    }

    private float[] GetXPositions(int count)
    {
        if (count == 1)
            return new[] { 0f };

        if (count == 2)
            return new[] { -100f, 100f };

        if (count == 3)
            return new[] { -150f, 0f, 150f };

        float spacing = 150f;
        float startX = -spacing * (count - 1) * 0.5f;
        float[] positions = new float[count];
        for (int i = 0; i < count; i++)
            positions[i] = startX + spacing * i;

        return positions;
    }

    private void SetIconLocalPosition(RawImage icon, float x, float y, float z)
    {
        if (icon == null)
            return;

        icon.rectTransform.anchoredPosition3D = new Vector3(x, y, z);
    }

    public bool AreAllEyesEnabled()
    {
        if (_eyesIcons == null || _eyesIcons.Length == 0)
            return false;

        for (int i = 0; i < _eyesIcons.Length; i++)
        {
            if (_eyesIcons[i] == null || !_eyesIcons[i].gameObject.activeSelf)
                return false;
        }

        return true;
    }

    public bool AreAllEyesDisabled()
    {
        if (_eyesIcons == null || _eyesIcons.Length == 0)
            return false;

        for (int i = 0; i < _eyesIcons.Length; i++)
        {
            if (_eyesIcons[i] != null && _eyesIcons[i].gameObject.activeSelf)
                return false;
        }

        return true;
    }

    public void StartFade(string msg, Action onComplete = null)
    {
        if (_fadeImg == null)
        {
            onComplete?.Invoke();
            return;
        }

        if (_fadeCoroutine != null)
            StopCoroutine(_fadeCoroutine);

        _fadeCoroutine = StartCoroutine(FadeRoutine(msg, onComplete));
    }

    private IEnumerator FadeRoutine(string msg, Action onComplete)
    {
        const float phaseDuration = 3f;

        SetImageAlpha(0f);
        SetTextAlpha(0f);

        _fadeImg.gameObject.SetActive(true);

        if (_fadeText != null)
        {
            _fadeText.gameObject.SetActive(true);
            _fadeText.text = msg;
        }

        float t = 0f;
        while (t < phaseDuration)
        {
            t += Time.deltaTime;
            float a = Mathf.Clamp01(t / phaseDuration);
            SetImageAlpha(a);
            SetTextAlpha(a);
            yield return null;
        }

        SetImageAlpha(1f);
        SetTextAlpha(1f);

        yield return new WaitForSeconds(phaseDuration);

        SetImageAlpha(0f);
        SetTextAlpha(0f);

        _fadeImg.gameObject.SetActive(false);
        if (_fadeText != null)
            _fadeText.gameObject.SetActive(false);

        _fadeCoroutine = null;
        onComplete?.Invoke();
    }

    private void SetImageAlpha(float a)
    {
        if (_fadeImg == null)
            return;

        Color c = _fadeImg.color;
        c.a = a;
        _fadeImg.color = c;
    }

    private void SetTextAlpha(float a)
    {
        if (_fadeText == null)
            return;

        Color c = _fadeText.color;
        c.a = a;
        _fadeText.color = c;
    }

    public void ResetEyes()
    {
        if (_eyesIcons != null)
        {
            for (int i = 0; i < _eyesIcons.Length; i++)
            {
                if (_eyesIcons[i] != null)
                    _eyesIcons[i].gameObject.SetActive(false);
            }
        }

        _nextEyeIndex = 0;
        WasFullyEnabled = false;
    }

    public bool HasAnyEnabledEyes()
    {
        if (_eyesIcons == null || _eyesIcons.Length == 0)
            return false;

        for (int i = 0; i < _eyesIcons.Length; i++)
        {
            if (_eyesIcons[i] != null && _eyesIcons[i].gameObject.activeSelf)
                return true;
        }

        return false;
    }
}
