using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using Vuforia;
using UnityEngine.Networking;
using FlutterUnityIntegration;
using TMPro;

public class ShowCanvasOnTarget : MonoBehaviour
{
    public GameObject canvasToShow; // Het canvas dat moet verschijnen
    public string shoeID; // Unieke ID van de schoen
    public string apiUrl = "https://thirty-rockets-yell.loca.lt/schoenen"; // Pas API-URL aan
    public TextMeshProUGUI detailsText; // Referentie naar de tekst binnen het canvas
    public Button detailsButton; // Referentie naar de knop in het canvas

    private ObserverBehaviour observerBehaviour;

    void Start()
    {
        observerBehaviour = GetComponent<ObserverBehaviour>();

        if (observerBehaviour)
        {
            observerBehaviour.OnTargetStatusChanged += OnTargetStatusChanged;
        }

        if (canvasToShow)
        {
            canvasToShow.SetActive(false);
        }

        if (detailsButton)
        {
            detailsButton.onClick.AddListener(OpenDetailsPage);
        }
    }

    private void OnTargetStatusChanged(ObserverBehaviour behaviour, TargetStatus targetStatus)
    {
        if (targetStatus.Status == Status.TRACKED || targetStatus.Status == Status.EXTENDED_TRACKED)
        {
            if (canvasToShow)
            {
                canvasToShow.SetActive(true);
                FetchShoeDetails(shoeID);
                PositionCanvas();
            }
        }
        else
        {
            if (canvasToShow)
            {
                canvasToShow.SetActive(false);
            }
        }
    }

    void PositionCanvas()
    {
        if (canvasToShow)
        {
            canvasToShow.transform.position = transform.position + Vector3.up * 0.5f;
            canvasToShow.transform.rotation = Quaternion.LookRotation(canvasToShow.transform.position - Camera.main.transform.position);
        }
    }

    void FetchShoeDetails(string shoeID)
    {
        StartCoroutine(FetchShoeDetailsCoroutine(shoeID));
    }

    IEnumerator FetchShoeDetailsCoroutine(string shoeID)
    {
        string url = $"{apiUrl}/{shoeID}";
        UnityWebRequest request = UnityWebRequest.Get(url);
        yield return request.SendWebRequest();

        if (request.result == UnityWebRequest.Result.Success)
        {
            string jsonResponse = request.downloadHandler.text;

            try
            {
                ShoeDetails details = JsonUtility.FromJson<ShoeDetails>(jsonResponse);
                detailsText.text = $"{details.name}\nMerk: {details.brand}\nPrijs: €{details.price:F2}\n{details.description}";
            }
            catch (System.Exception e)
            {
                detailsText.text = "Fout bij verwerken van details.";
                Debug.LogError($"Error parsing JSON: {e.Message}");
            }
        }
        else
        {
            detailsText.text = "Fout bij ophalen details.";
            Debug.LogError($"Error fetching details: {request.error}");
        }
    }

    void OpenDetailsPage()
    {
        var message = JsonUtility.ToJson(new { shoeID = shoeID });
        UnityMessageManager.Instance.SendMessageToFlutter(message);
    }

    void OnDestroy()
    {
        if (observerBehaviour)
        {
            observerBehaviour.OnTargetStatusChanged -= OnTargetStatusChanged;
        }
    }
}

[System.Serializable]
public class ShoeDetails
{
    public string name;
    public string brand;
    public float price;
    public string description;
}
