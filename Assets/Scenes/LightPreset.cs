using UnityEngine;

[CreateAssetMenu(menuName = "Lighting/Light Preset")]
public class LightPreset : ScriptableObject
{
    public AnimationCurve startCurve;
    public AnimationCurve loopCurve;
    public AnimationCurve endCurve;

    public AnimationCurve dirStartCurve;
    public AnimationCurve dirLoopCurve;
    public AnimationCurve dirEndCurve;
}