using System;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UIManager : MonoBehaviour
{
    [SerializeField] private GameObject[] _eyesIcons;
    [SerializeField] private Image _fadeImg;
    [SerializeField] private TMPro.TextMeshProUGUI _fadeText;

    [SerializeField] private GameObject _resultUIObject;
    [SerializeField] private Slider _resultSlider;

    private int _nextEyeIndex = 0;
    public bool WasFullyEnabled { get; private set; } = false;
    private Coroutine _fadeCoroutine;

    void Start()
    {
        if (_eyesIcons != null)
        {
            for (int i = 0; i < _eyesIcons.Length; i++)
            {
                if (_eyesIcons[i] != null)
                    _eyesIcons[i].SetActive(false);
            }
        }

        _nextEyeIndex = 0;
        WasFullyEnabled = false;

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

    void Update()
    {
    }

    public void EnableNextEyeIcon()
    {
        if (_eyesIcons == null || _nextEyeIndex >= _eyesIcons.Length)
            return;

        var go = _eyesIcons[_nextEyeIndex];
        if (go != null)
            go.SetActive(true);

        _nextEyeIndex++;

        if (_nextEyeIndex >= _eyesIcons.Length)
            WasFullyEnabled = true;
    }

    public void DisableEyeAtIndex(int index)
    {
        Debug.Log("비활성화 요청 인덱스: " + index);
        if (_eyesIcons == null)
            return;

        if (index < 0 || index >= _eyesIcons.Length)
            return;

        var go = _eyesIcons[index];
        if (go != null)
            go.SetActive(false);

        if (index < _nextEyeIndex)
            _nextEyeIndex = index;
    }

    public bool DisableFirstEnabledEye()
    {
        if (_eyesIcons == null || _eyesIcons.Length == 0)
            return false;

        for (int i = 0; i < _eyesIcons.Length; i++)
        {
            if (_eyesIcons[i] != null && _eyesIcons[i].activeSelf)
            {
                _eyesIcons[i].SetActive(false);
                if (i < _nextEyeIndex)
                    _nextEyeIndex = i;
                return true;
            }
        }

        return false;
    }

    public bool AreAllEyesEnabled()
    {
        if (_eyesIcons == null || _eyesIcons.Length == 0)
            return false;

        for (int i = 0; i < _eyesIcons.Length; i++)
        {
            if (_eyesIcons[i] == null || !_eyesIcons[i].activeSelf)
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
            if (_eyesIcons[i] != null && _eyesIcons[i].activeSelf)
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
                    _eyesIcons[i].SetActive(false);
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
            if (_eyesIcons[i] != null && _eyesIcons[i].activeSelf)
                return true;
        }

        return false;
    }
}
