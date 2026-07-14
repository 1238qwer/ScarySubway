using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class OptionManager : MonoBehaviour
{
    [SerializeField] private GameObject _optionPanel;

    [Header("UI References (Optional)")]
    [SerializeField] private TMP_Dropdown _resolutionDropdown;
    [SerializeField] private TMP_Dropdown _windowModeDropdown;
    [SerializeField] private TMP_Dropdown _qualityDropdown;
    [SerializeField] private TMP_Dropdown _antiAliasingDropdown;
    [SerializeField] private Toggle _vSyncToggle;
    [SerializeField] private TMP_Dropdown _frameRateDropdown;
    [SerializeField] private Slider _masterVolumeSlider;

    private readonly List<Resolution> _availableResolutions = new List<Resolution>();

    private const string KeyResolutionIndex = "option_resolution_index";
    private const string KeyWindowMode = "option_window_mode";
    private const string KeyQuality = "option_quality";
    private const string KeyAntiAliasing = "option_aa";
    private const string KeyVSync = "option_vsync";
    private const string KeyFrameRate = "option_fps";
    private const string KeyMasterVolume = "option_master_volume";

    private static readonly int[] AntiAliasingValues = { 0, 2, 4, 8 };
    private static readonly int[] FrameRateValues = { 30, 60, 120, 144, -1 };

    private OptionValues _systemInitialValues;
    private OptionValues _appliedValues;
    private OptionValues _pendingValues;

    private sealed class OptionValues
    {
        public int ResolutionIndex;
        public int WindowModeIndex;
        public int QualityIndex;
        public int AntiAliasingIndex;
        public bool UseVSync;
        public int FrameRateIndex;
        public float MasterVolume;

        public OptionValues Clone()
        {
            return new OptionValues
            {
                ResolutionIndex = ResolutionIndex,
                WindowModeIndex = WindowModeIndex,
                QualityIndex = QualityIndex,
                AntiAliasingIndex = AntiAliasingIndex,
                UseVSync = UseVSync,
                FrameRateIndex = FrameRateIndex,
                MasterVolume = MasterVolume
            };
        }
    }

    private void Start()
    {
        BuildResolutionOptions();
        BuildStaticDropdownOptions();

        _systemInitialValues = CaptureCurrentValues();

        OptionValues loaded = LoadValuesFromPrefs();
        ApplyValues(loaded);

        _appliedValues = CaptureCurrentValues();
        _pendingValues = _appliedValues.Clone();

        RefreshUIFromPending();

        _optionPanel?.SetActive(false);
    }

    public void ToggleOptionPanel()
    {
        if (_optionPanel == null)
            return;

        bool next = !_optionPanel.activeSelf;
        _optionPanel.SetActive(next);

        if (next)
        {
            _pendingValues = _appliedValues.Clone();
            RefreshUIFromPending();
        }
    }

    public void OnResolutionDropdownChanged(int index)
    {
        if (_pendingValues == null)
            return;

        _pendingValues.ResolutionIndex = Mathf.Clamp(index, 0, _availableResolutions.Count - 1);
    }

    public void OnWindowModeDropdownChanged(int modeIndex)
    {
        if (_pendingValues == null)
            return;

        _pendingValues.WindowModeIndex = Mathf.Clamp(modeIndex, 0, 2);
    }

    public void OnQualityDropdownChanged(int qualityIndex)
    {
        if (_pendingValues == null)
            return;

        _pendingValues.QualityIndex = Mathf.Clamp(qualityIndex, 0, Mathf.Max(0, QualitySettings.names.Length - 1));
    }

    public void OnAntiAliasingDropdownChanged(int aaIndex)
    {
        if (_pendingValues == null)
            return;

        _pendingValues.AntiAliasingIndex = Mathf.Clamp(aaIndex, 0, AntiAliasingValues.Length - 1);
    }

    public void OnVSyncToggleChanged(bool isOn)
    {
        if (_pendingValues == null)
            return;

        _pendingValues.UseVSync = isOn;
    }

    public void OnFrameRateDropdownChanged(int fpsIndex)
    {
        if (_pendingValues == null)
            return;

        _pendingValues.FrameRateIndex = Mathf.Clamp(fpsIndex, 0, FrameRateValues.Length - 1);
    }

    public void OnMasterVolumeSliderChanged(float volume)
    {
        if (_pendingValues == null)
            return;

        _pendingValues.MasterVolume = Mathf.Clamp01(volume);
    }

    // Apply 버튼에 연결
    public void ApplyPendingOptions()
    {
        if (_pendingValues == null)
            return;

        ApplyValues(_pendingValues);
        _appliedValues = CaptureCurrentValues();
        SaveValuesToPrefs(_appliedValues);
        RefreshUIFromPending();
    }

    // Rollback 버튼에 연결 (시스템 초기값으로 즉시 복원)
    public void RollbackToSystemInitial()
    {
        if (_systemInitialValues == null)
            return;

        ApplyValues(_systemInitialValues);
        _appliedValues = CaptureCurrentValues();
        _pendingValues = _appliedValues.Clone();
        RefreshUIFromPending();
    }

    private void BuildResolutionOptions()
    {
        _availableResolutions.Clear();

        Resolution[] all = Screen.resolutions;
        HashSet<string> unique = new HashSet<string>();

        for (int i = 0; i < all.Length; i++)
        {
            Resolution r = all[i];
            string key = r.width + "x" + r.height;

            if (unique.Add(key))
                _availableResolutions.Add(r);
        }

        if (_availableResolutions.Count == 0)
            _availableResolutions.Add(Screen.currentResolution);

        if (_resolutionDropdown == null)
            return;

        _resolutionDropdown.ClearOptions();

        List<string> options = new List<string>(_availableResolutions.Count);
        for (int i = 0; i < _availableResolutions.Count; i++)
        {
            Resolution r = _availableResolutions[i];
            options.Add(r.width + " x " + r.height);
        }

        _resolutionDropdown.AddOptions(options);
    }

    private void BuildStaticDropdownOptions()
    {
        if (_windowModeDropdown != null)
        {
            _windowModeDropdown.ClearOptions();
            _windowModeDropdown.AddOptions(new List<string> { "전체 화면", "테두리 없는 창", "창 모드" });
        }

        if (_qualityDropdown != null)
        {
            _qualityDropdown.ClearOptions();
            _qualityDropdown.AddOptions(new List<string>(QualitySettings.names));
        }

        if (_antiAliasingDropdown != null)
        {
            _antiAliasingDropdown.ClearOptions();
            _antiAliasingDropdown.AddOptions(new List<string> { "AA 끔", "AA 2x", "AA 4x", "AA 8x" });
        }

        if (_frameRateDropdown != null)
        {
            _frameRateDropdown.ClearOptions();
            _frameRateDropdown.AddOptions(new List<string> { "30 FPS", "60 FPS", "120 FPS", "144 FPS", "제한 없음" });
        }
    }

    private void ApplyValues(OptionValues values)
    {
        if (values == null)
            return;

        ApplyWindowMode(values.WindowModeIndex);
        ApplyResolutionByIndex(values.ResolutionIndex);
        ApplyQualityLevel(values.QualityIndex);
        ApplyAntiAliasingByIndex(values.AntiAliasingIndex);
        ApplyVSync(values.UseVSync);
        ApplyFrameRateByIndex(values.FrameRateIndex);
        ApplyMasterVolume(values.MasterVolume);
    }

    private OptionValues CaptureCurrentValues()
    {
        return new OptionValues
        {
            ResolutionIndex = Mathf.Clamp(GetCurrentResolutionIndex(), 0, Mathf.Max(0, _availableResolutions.Count - 1)),
            WindowModeIndex = GetWindowModeIndex(Screen.fullScreenMode),
            QualityIndex = Mathf.Clamp(QualitySettings.GetQualityLevel(), 0, Mathf.Max(0, QualitySettings.names.Length - 1)),
            AntiAliasingIndex = GetAntiAliasingIndex(QualitySettings.antiAliasing),
            UseVSync = QualitySettings.vSyncCount > 0,
            FrameRateIndex = GetFrameRateIndex(Application.targetFrameRate),
            MasterVolume = AudioListener.volume
        };
    }

    private OptionValues LoadValuesFromPrefs()
    {
        OptionValues defaults = _systemInitialValues ?? CaptureCurrentValues();

        return new OptionValues
        {
            ResolutionIndex = PlayerPrefs.GetInt(KeyResolutionIndex, defaults.ResolutionIndex),
            WindowModeIndex = PlayerPrefs.GetInt(KeyWindowMode, defaults.WindowModeIndex),
            QualityIndex = PlayerPrefs.GetInt(KeyQuality, defaults.QualityIndex),
            AntiAliasingIndex = GetAntiAliasingIndex(PlayerPrefs.GetInt(KeyAntiAliasing, AntiAliasingValues[defaults.AntiAliasingIndex])),
            UseVSync = PlayerPrefs.GetInt(KeyVSync, defaults.UseVSync ? 1 : 0) == 1,
            FrameRateIndex = GetFrameRateIndex(PlayerPrefs.GetInt(KeyFrameRate, FrameRateValues[defaults.FrameRateIndex])),
            MasterVolume = PlayerPrefs.GetFloat(KeyMasterVolume, defaults.MasterVolume)
        };
    }

    private void SaveValuesToPrefs(OptionValues values)
    {
        PlayerPrefs.SetInt(KeyResolutionIndex, values.ResolutionIndex);
        PlayerPrefs.SetInt(KeyWindowMode, values.WindowModeIndex);
        PlayerPrefs.SetInt(KeyQuality, values.QualityIndex);
        PlayerPrefs.SetInt(KeyAntiAliasing, AntiAliasingValues[Mathf.Clamp(values.AntiAliasingIndex, 0, AntiAliasingValues.Length - 1)]);
        PlayerPrefs.SetInt(KeyVSync, values.UseVSync ? 1 : 0);
        PlayerPrefs.SetInt(KeyFrameRate, FrameRateValues[Mathf.Clamp(values.FrameRateIndex, 0, FrameRateValues.Length - 1)]);
        PlayerPrefs.SetFloat(KeyMasterVolume, values.MasterVolume);
        PlayerPrefs.Save();
    }

    private void RefreshUIFromPending()
    {
        if (_pendingValues == null)
            return;

        _resolutionDropdown?.SetValueWithoutNotify(Mathf.Clamp(_pendingValues.ResolutionIndex, 0, Mathf.Max(0, _availableResolutions.Count - 1)));
        _windowModeDropdown?.SetValueWithoutNotify(Mathf.Clamp(_pendingValues.WindowModeIndex, 0, 2));
        _qualityDropdown?.SetValueWithoutNotify(Mathf.Clamp(_pendingValues.QualityIndex, 0, Mathf.Max(0, QualitySettings.names.Length - 1)));
        _antiAliasingDropdown?.SetValueWithoutNotify(Mathf.Clamp(_pendingValues.AntiAliasingIndex, 0, AntiAliasingValues.Length - 1));
        _vSyncToggle?.SetIsOnWithoutNotify(_pendingValues.UseVSync);
        _frameRateDropdown?.SetValueWithoutNotify(Mathf.Clamp(_pendingValues.FrameRateIndex, 0, FrameRateValues.Length - 1));
        _masterVolumeSlider?.SetValueWithoutNotify(Mathf.Clamp01(_pendingValues.MasterVolume));
    }

    private void ApplyResolutionByIndex(int index)
    {
        if (_availableResolutions.Count == 0)
            return;

        int clamped = Mathf.Clamp(index, 0, _availableResolutions.Count - 1);
        Resolution selected = _availableResolutions[clamped];

        Screen.SetResolution(
            selected.width,
            selected.height,
            Screen.fullScreenMode,
            selected.refreshRateRatio);
    }

    private void ApplyWindowMode(int modeIndex)
    {
        FullScreenMode mode = FullScreenMode.FullScreenWindow;

        switch (modeIndex)
        {
            case 0:
                mode = FullScreenMode.ExclusiveFullScreen;
                break;
            case 1:
                mode = FullScreenMode.FullScreenWindow;
                break;
            case 2:
                mode = FullScreenMode.Windowed;
                break;
        }

        Screen.fullScreenMode = mode;
    }

    private void ApplyQualityLevel(int qualityIndex)
    {
        int clamped = Mathf.Clamp(qualityIndex, 0, Mathf.Max(0, QualitySettings.names.Length - 1));
        QualitySettings.SetQualityLevel(clamped, true);
    }

    private void ApplyAntiAliasingByIndex(int aaIndex)
    {
        int clamped = Mathf.Clamp(aaIndex, 0, AntiAliasingValues.Length - 1);
        QualitySettings.antiAliasing = AntiAliasingValues[clamped];
    }

    private void ApplyVSync(bool isOn)
    {
        QualitySettings.vSyncCount = isOn ? 1 : 0;
    }

    private void ApplyFrameRateByIndex(int fpsIndex)
    {
        int clamped = Mathf.Clamp(fpsIndex, 0, FrameRateValues.Length - 1);
        Application.targetFrameRate = FrameRateValues[clamped];
    }

    private void ApplyMasterVolume(float value)
    {
        AudioListener.volume = Mathf.Clamp01(value);
    }

    private int GetCurrentResolutionIndex()
    {
        for (int i = 0; i < _availableResolutions.Count; i++)
        {
            Resolution r = _availableResolutions[i];
            if (r.width == Screen.width && r.height == Screen.height)
                return i;
        }

        return Mathf.Max(0, _availableResolutions.Count - 1);
    }

    private int GetWindowModeIndex(FullScreenMode mode)
    {
        switch (mode)
        {
            case FullScreenMode.ExclusiveFullScreen:
                return 0;
            case FullScreenMode.FullScreenWindow:
                return 1;
            default:
                return 2;
        }
    }

    private int GetAntiAliasingIndex(int aaValue)
    {
        for (int i = 0; i < AntiAliasingValues.Length; i++)
        {
            if (AntiAliasingValues[i] == aaValue)
                return i;
        }

        return 0;
    }

    private int GetFrameRateIndex(int frameRate)
    {
        for (int i = 0; i < FrameRateValues.Length; i++)
        {
            if (FrameRateValues[i] == frameRate)
                return i;
        }

        return 1;
    }
}
