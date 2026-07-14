using UnityEngine;

public class PosterAnomaly : AnomalyBehaviour
{
    [SerializeField] private GameObject[] _posters;
    public override void Activate()
    {
        foreach (GameObject go in _posters)
        {
            if (go != null)
                go.SetActive(true);
        }
    }

    public override void Deactivate()
    {
        foreach (GameObject go in _posters)
        {
            if (go != null)
                go.SetActive(false);
        }
    }

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
