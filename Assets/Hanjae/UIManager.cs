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

    private int _nextEyeIndex = 0;

    // 한 번이라도 모든 아이콘이 켜졌는지를 나타내는 플래그
    public bool WasFullyEnabled { get; private set; } = false;

    private Coroutine _fadeCoroutine;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        // 모든 아이콘을 처음에 끈다
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
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    // 다음 아이콘을 하나 켠다. 이미 모두 켜져 있으면 아무 작업도 하지 않는다.
    public void EnableNextEyeIcon()
    {
        if (_eyesIcons == null || _nextEyeIndex >= _eyesIcons.Length)
            return;

        var go = _eyesIcons[_nextEyeIndex];
        if (go != null)
            go.SetActive(true);

        _nextEyeIndex++;

        // 모든 아이콘이 한 번이라도 켜졌다면 플래그 설정 (플래그는 이후 Disable로 꺼져도 유지됨)
        if (_nextEyeIndex >= _eyesIcons.Length)
            WasFullyEnabled = true;
    }

    // 지정한 인덱스(0-based)의 아이콘 비활성화
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

        // 다음 EnableNextEyeIcon 호출이 이 빈 슬롯을 채우도록 인덱스 조정
        if (index < _nextEyeIndex)
            _nextEyeIndex = index;

        // 주의: WasFullyEnabled 플래그는 한 번 true가 되면 유지한다(필요하면 ResetEyes로 리셋)
    }

    // 모든 아이콘이 현재 활성화되어 있는지 확인하는 헬퍼
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

    // 모든 아이콘이 현재 비활성화되어 있는지 확인하는 헬퍼
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

    // 페이드 연출 시작: msg를 텍스트로 표시하고 이미지 알파를 0 -> 1(0.3s) 유지(0.3s) -> 0(0.3s)
    // onComplete: 페이드가 완전히 종료된 후 호출될 콜백 (선택적)
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
        const float phaseDuration = 0.3f;

        // 먼저 알파를 0으로 설정한 뒤 활성화하여 "최대에서 시작" 깜박임을 방지
        SetImageAlpha(0f);
        SetTextAlpha(0f);

        _fadeImg.gameObject.SetActive(true);

        if (_fadeText != null)
        {
            _fadeText.gameObject.SetActive(true);
            _fadeText.text = msg;
        }

        // 페이드 인 (0 -> 1)
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

        // 유지
        yield return new WaitForSeconds(phaseDuration);

        // 페이드 아웃 (1 -> 0)
        t = 0f;
        while (t < phaseDuration)
        {
            t += Time.deltaTime;
            float a = Mathf.Clamp01(1f - (t / phaseDuration));
            SetImageAlpha(a);
            SetTextAlpha(a);
            yield return null;
        }
        SetImageAlpha(0f);
        SetTextAlpha(0f);

        // 종료: 비활성화
        _fadeImg.gameObject.SetActive(false);
        if (_fadeText != null)
            _fadeText.gameObject.SetActive(false);

        _fadeCoroutine = null;

        // 완료 콜백 호출
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

    // 외부에서 사이클을 새로 시작할 때 눈 상태와 내부 플래그를 초기화
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
}
