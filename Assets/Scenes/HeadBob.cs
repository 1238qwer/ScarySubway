using UnityEngine;
using UnityEngine.InputSystem;

public class HeadBob : MonoBehaviour
{
    public CharacterController controller;

    [Header("Normal Bob")]
    public float bobSpeed = 14f;
    public float bobAmount = 0.05f;

    [Header("Subway Jerk")]
    public float jerkIntervalMin = 2f;
    public float jerkIntervalMax = 5f;
    public float jerkAmount = 0.15f;
    public float jerkReturnSpeed = 8f;

    private float defaultYPos;
    private float timer;

    // subway state
    private float jerkTimer;
    private float jerkValue;
    private float nextJerkTime;

    public enum HeadBobMode
    {
        Normal,
        Subway
    }

    public HeadBobMode mode = HeadBobMode.Normal;

    void Start()
    {
        defaultYPos = transform.localPosition.y;
        SetNextJerkTime();
    }

    void Update()
    {
        HandleInput();

        bool isMoving = controller.velocity.magnitude > 0.1f && controller.isGrounded;

        if (!isMoving)
        {
            ResetBob();
            return;
        }

        switch (mode)
        {
            case HeadBobMode.Normal:
                ApplyNormalBob();
                break;

            case HeadBobMode.Subway:
                ApplySubwayBob();
                break;
        }
    }

    // ----------------------------
    // INPUT CONTROL
    // ----------------------------
    void HandleInput()
    {
        if (Keyboard.current.digit3Key.wasPressedThisFrame)
        {
            mode = HeadBobMode.Normal;
        }
        else if (Keyboard.current.digit4Key.wasPressedThisFrame)
        {
            mode = HeadBobMode.Subway;
        }
        else if (Keyboard.current.digit5Key.wasPressedThisFrame)
        {
            ResetBob();
        }
    }

    // ----------------------------
    // NORMAL BOB
    // ----------------------------
    void ApplyNormalBob()
    {
        timer += Time.deltaTime * bobSpeed;

        float sinOffset = Mathf.Sin(timer) * bobAmount;

        Vector3 pos = transform.localPosition;
        pos.y = defaultYPos + sinOffset;
        transform.localPosition = pos;
    }

    // ----------------------------
    // SUBWAY BOB
    // ----------------------------
    // ----------------------------
    // SUBWAY BOB (IMPROVED)
    // ----------------------------
    void ApplySubwayBob()
    {
        timer += Time.deltaTime;

        // -----------------------------------
        // 1. 상태 기반 흔들림 강도 변화
        // -----------------------------------
        float stateNoise = Mathf.PerlinNoise(Time.time * 0.2f, 0f);

        float amplitudeMultiplier = 1f;
        float speedMultiplier = 1f;
        float jerkMultiplier = 1f;

        if (stateNoise < 0.3f)
        {
            // calm section
            amplitudeMultiplier = 0.6f;
            speedMultiplier = 0.8f;
            jerkMultiplier = 0.3f;
        }
        else if (stateNoise < 0.7f)
        {
            // normal subway vibration
            amplitudeMultiplier = 1f;
            speedMultiplier = 1f;
            jerkMultiplier = 1f;
        }
        else
        {
            // turbulence (train shake / braking)
            amplitudeMultiplier = 2.0f;
            speedMultiplier = 1.3f;
            jerkMultiplier = 3.0f;
        }

        // -----------------------------------
        // 2. 기본 진동 (상태 반영된 sin)
        // -----------------------------------
        float wave = Mathf.Sin(timer * bobSpeed * speedMultiplier)
                     * bobAmount * amplitudeMultiplier;

        // -----------------------------------
        // 3. 충격성 덜컹 (비정기 + 가중)
        // -----------------------------------
        jerkTimer += Time.deltaTime;

        float dynamicInterval = Mathf.Lerp(
            jerkIntervalMax,
            jerkIntervalMin,
            stateNoise
        );

        if (jerkTimer >= dynamicInterval)
        {
            jerkTimer = 0f;

            // "툭"이 아니라 "쿵" 느낌
            jerkValue += Random.Range(-jerkAmount, jerkAmount) * jerkMultiplier;
        }

        // -----------------------------------
        // 4. 빠른 감쇠 (지하철 핵심 느낌)
        // -----------------------------------
        float decaySpeed = jerkReturnSpeed;

        // turbulence일수록 잔향 길게
        if (stateNoise > 0.7f)
            decaySpeed *= 0.6f;

        jerkValue = Mathf.Lerp(jerkValue, 0f, Time.deltaTime * decaySpeed);

        // -----------------------------------
        // 5. 최종 합성
        // -----------------------------------
        Vector3 pos = transform.localPosition;
        pos.y = defaultYPos + wave + jerkValue;
        transform.localPosition = pos;
    }

    // ----------------------------
    // RESET
    // ----------------------------
    void ResetBob()
    {
        timer = 0f;
        jerkValue = 0f;

        Vector3 pos = transform.localPosition;
        pos.y = Mathf.Lerp(pos.y, defaultYPos, Time.deltaTime * 5f);
        transform.localPosition = pos;
    }

    // ----------------------------
    // UTILITY
    // ----------------------------
    void SetNextJerkTime()
    {
        nextJerkTime = Random.Range(jerkIntervalMin, jerkIntervalMax);
    }
}