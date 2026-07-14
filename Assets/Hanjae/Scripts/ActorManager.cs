using System.Collections.Generic;
using UnityEngine;

public class ActorManager : MonoBehaviour
{
    [SerializeField] private Actor[] _actors;

    public Actor[] Actors => _actors;

    public void ActivateRandomHalfActors()
    {
        if (_actors == null || _actors.Length == 0)
            return;

        List<int> validIndices = new List<int>();
        for (int i = 0; i < _actors.Length; i++)
        {
            if (_actors[i] != null)
                validIndices.Add(i);
        }

        if (validIndices.Count == 0)
            return;

        for (int i = validIndices.Count - 1; i > 0; i--)
        {
            int swapIndex = Random.Range(0, i + 1);
            int temp = validIndices[i];
            validIndices[i] = validIndices[swapIndex];
            validIndices[swapIndex] = temp;
        }

        int activeCount = validIndices.Count / 2;

        for (int i = 0; i < validIndices.Count; i++)
        {
            int actorIndex = validIndices[i];
            bool shouldActive = i < activeCount;
            _actors[actorIndex].gameObject.SetActive(shouldActive);
        }
    }
}