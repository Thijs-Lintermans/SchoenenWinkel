using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Vuforia;

public class ShowObjectOnTarget : MonoBehaviour
{
    public GameObject objectToShow; // Het object dat moet verschijnen
    private ObserverBehaviour observerBehaviour;

    void Start()
    {
        observerBehaviour = GetComponent<ObserverBehaviour>();

        if (observerBehaviour)
        {
            observerBehaviour.OnTargetStatusChanged += OnTargetStatusChanged;
        }

        // Zorg dat het object standaard niet zichtbaar is
        if (objectToShow)
        {
            objectToShow.SetActive(false);
        }
    }

    private void OnTargetStatusChanged(ObserverBehaviour behaviour, TargetStatus targetStatus)
    {
        // Controleer of het target herkend is
        if (targetStatus.Status == Status.TRACKED || targetStatus.Status == Status.EXTENDED_TRACKED)
        {
            if (objectToShow)
            {
                objectToShow.SetActive(true);
            }
        }
        else
        {
            if (objectToShow)
            {
                objectToShow.SetActive(false);
            }
        }
    }

    void OnDestroy()
    {
        if (observerBehaviour)
        {
            observerBehaviour.OnTargetStatusChanged -= OnTargetStatusChanged;
        }
    }
}
