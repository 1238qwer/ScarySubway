using UnityEngine;

[CreateAssetMenu(menuName = "HeadBob/Head Bob Preset")]
public class HeadBobPreset : ScriptableObject
{
    public AnimationCurve startCurve;
    public AnimationCurve loopCurve;
    public AnimationCurve endCurve;
}