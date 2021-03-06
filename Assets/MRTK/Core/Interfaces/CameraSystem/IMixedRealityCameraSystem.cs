// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace Microsoft.MixedReality.Toolkit.CameraSystem
{
    /// <summary>
    /// Manager interface for a camera system in the Mixed Reality Toolkit.
    /// The camera system is expected to manage settings on the main camera.
    /// It should update the camera's clear settings, render mask, etc based on platform.
    /// </summary>
    public interface IMixedRealityCameraSystem : IMixedRealityEventSystem, IMixedRealityEventSource, IMixedRealityService
    {
        /// <summary>
        /// Typed representation of the ConfigurationProfile property.
        /// </summary>
        MixedRealityCameraProfile CameraProfile { get; }

        /// <summary>
        /// Is the current camera displaying on an opaque (VR / immersive) or a transparent (AR) device
        /// </summary>
        bool IsOpaque { get; }
    }
}