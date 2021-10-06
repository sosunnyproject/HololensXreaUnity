/*===============================================================================
Copyright (c) 2020 PTC Inc. All Rights Reserved.

Vuforia is a trademark of PTC Inc., registered in the United States and other
countries.
===============================================================================*/


using System;
using System.IO;
using System.Linq;
using UnityEngine;
using Vuforia;

/// <summary>
/// When using the Mixed Reality Toolkit in a project with multiple scenes, Microsoft advises to
/// use the MRTK Scene System to manage scene loading. This system relies on a Manager scenes 
/// loaded at startup, and multiple Content scenes being additvely loaded along with it. 
/// By default, Vuforia attaches itself to the MainCamera when it is initialized. Usually, each 
/// Vuforia scene in the project would have an ARCamera and Vuforia would be completely initialized 
/// and deinitialized every time a scene is loaded or unloaded. 
/// The Manager scene contains the MainCamera and is never unloaded, so Vuforia is initialized at 
/// startup time and never deinitialized when switching scenes.
/// To correctly manage Vuforia's lifecyle with the MRTK Scene System we need this class that
/// calls the appropriate VuforiaRuntime methods when a scene is loaded or unloaded.
/// </summary>
public class VuforiaAdditiveSceneLoader : MonoBehaviour
{
    [Tooltip("The list of DataSets that need to be active as soon as the scene is loaded.")]
    public string[] DataSetsToActivate;

    private Action mOnVuforiaStarted;

    void OnEnable()
    {
        // When a new scene is loaded, we make sure that the VuforiaBehaviour is enabled.
        if (VuforiaBehaviour.Instance && !VuforiaBehaviour.Instance.isActiveAndEnabled)
            VuforiaBehaviour.Instance.enabled = true;

        if (DataSetsToActivate.Length == 0)
            return;

        mOnVuforiaStarted = () => { OnVuforiaStarted(DataSetsToActivate); };

        VuforiaARController.Instance.RegisterVuforiaStartedCallback(mOnVuforiaStarted);
    }

    void OnDisable()
    {
        VuforiaARController.Instance.UnregisterVuforiaStartedCallback(mOnVuforiaStarted);

        // When a scene is unloaded, we need to destroy all the loaded DataSets and the associated
        // Trackables.
        VuforiaRuntimeUtilities.DestroyAllDataSetsAndTrackables();

        if (VuforiaBehaviour.Instance == null)
            return;

        // Because the camera the VuforiaBehaviour is attached to does not get destroyed when
        // switching scenes, we need to manually destroy the Behaviour and recreate it to restart
        // Vuforia in a clean state
        var vuforiaBehaviourGameObject = VuforiaBehaviour.Instance.gameObject;
        GameObject.DestroyImmediate(VuforiaBehaviour.Instance);
        vuforiaBehaviourGameObject.AddComponent<VuforiaBehaviour>();
    }

    void OnVuforiaStarted(string[] datasets)
    {
        var objectTracker = TrackerManager.Instance.GetTracker<ObjectTracker>();

        // Add to the list of datasets to load only the ones that are not already active.
        var activeDataSets = objectTracker.GetActiveDataSets().Select(ds => Path.GetFileNameWithoutExtension(ds.Path));
        var datasetsToLoad = datasets.Where(ds => DataSet.Exists(ds)).Except(activeDataSets);

        foreach (var datasetName in datasetsToLoad)
        {
            var dataset = objectTracker.CreateDataSet();

            if (dataset.Load(datasetName))
                objectTracker.ActivateDataSet(dataset);
            else
                Debug.LogError("Failed to load DataSet: " + datasetName);
        }

        // We need to reassociate the trackables in case the needed DataSet already exists in the scene
        TrackerManager.Instance.GetStateManager().ReassociateTrackables();
        objectTracker.Start();
    }
}

