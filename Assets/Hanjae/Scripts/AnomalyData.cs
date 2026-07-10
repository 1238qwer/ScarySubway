using UnityEngine;

[CreateAssetMenu(menuName = "Anomaly/Stage")]
public class AnomalyData : ScriptableObject
{
    [SerializeField] private string anomalyID;
    public string AnomalyID => anomalyID;
}