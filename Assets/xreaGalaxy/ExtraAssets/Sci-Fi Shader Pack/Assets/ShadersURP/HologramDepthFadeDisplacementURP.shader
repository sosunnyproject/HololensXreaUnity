// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HologramDepthFadeDisplacementURP"
{
	Properties
	{
		_Hologram1("Hologram", 2D) = "white" {}
		_ObjectHigh("ObjectHigh", Float) = 0
		_ObjectLow("ObjectLow", Float) = 0
		_Scale("Scale", Float) = 1
		_Power("Power", Float) = 1
		[HDR]_FirstColor("FirstColor", Color) = (0,0,0,0)
		[HDR]_SecondColor("SecondColor", Color) = (0,0,0,0)
		_DepthPower("DepthPower", Float) = 0
		[Toggle(_INVERT1_ON)] _Invert1("Invert", Float) = 0
		_UV("UV", Float) = 1
		_VertexMovement("VertexMovement", Float) = 0.02
		_Const5("Const4", Float) = 2

	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
		
		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL

		
		Pass
		{
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend SrcAlpha OneMinusSrcAlpha , One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#pragma shader_feature _INVERT1_ON


			sampler2D _Hologram1;
			float _ShaderHologramDisplacement;
			uniform float4 _CameraDepthTexture_TexelSize;
			CBUFFER_START( UnityPerMaterial )
			float _UV;
			float _Scale;
			float _Power;
			float _VertexMovement;
			float _ObjectLow;
			float _ObjectHigh;
			float4 _FirstColor;
			float4 _SecondColor;
			float _Const5;
			float _DepthPower;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				float4 shadowCoord : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2Dlod( _Hologram1, float4( panner42, 0, 0.0) ) * staticSwitch54 );
				float temp_output_13_0 = ( 0.0 + (_ObjectLow + (_ShaderHologramDisplacement - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0)) );
				float vpY9 = v.vertex.xyz.y;
				float temp_output_23_0 = ( temp_output_13_0 - vpY9 );
				float clampResult31 = clamp( temp_output_23_0 , 0.0 , temp_output_23_0 );
				float4 appendResult47 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult31 ) , 0.0 , 0.0));
				float smoothstepResult36 = smoothstep( ( temp_output_13_0 - 0.2 ) , ( temp_output_13_0 + 0.2 ) , vpY9);
				float4 vertex57 = ( appendResult47 * smoothstepResult36 );
				float smoothstepResult28 = smoothstep( ( temp_output_13_0 - 0.5 ) , ( temp_output_13_0 + 0.5 ) , vpY9);
				float mask38 = smoothstepResult28;
				float4 lerpResult70 = lerp( ( temp_output_56_0 * _VertexMovement ) , vertex57 , mask38);
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord8 = screenPos;
				
				o.ase_texcoord7 = v.vertex;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = lerpResult70.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 lwWNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
				float3 lwWTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float3 lwWBinormal = normalize(cross(lwWNormal, lwWTangent) * v.ase_tangent.w);
				o.tSpace0 = float4(lwWTangent.x, lwWBinormal.x, lwWNormal.x, lwWorldPos.x);
				o.tSpace1 = float4(lwWTangent.y, lwWBinormal.y, lwWNormal.y, lwWorldPos.y);
				o.tSpace2 = float4(lwWTangent.z, lwWBinormal.z, lwWNormal.z, lwWorldPos.z);

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
				
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH.xyz );

				half3 vertexLight = VertexLighting(vertexInput.positionWS, lwWNormal);
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( vertexInput.positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				o.clipPos = vertexInput.positionCS;

				#ifdef _MAIN_LIGHT_SHADOWS
					o.shadowCoord = GetShadowCoord(vertexInput);
				#endif
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float3 WorldSpaceNormal = normalize(float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z));
				float3 WorldSpaceTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldSpaceBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldSpacePosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldSpaceViewDirection = _WorldSpaceCameraPos.xyz  - WorldSpacePosition;
	
				#if SHADER_HINT_NICE_QUALITY
					WorldSpaceViewDirection = SafeNormalize( WorldSpaceViewDirection );
				#endif

				float temp_output_13_0 = ( 0.0 + (_ObjectLow + (_ShaderHologramDisplacement - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0)) );
				float vpY9 = IN.ase_texcoord7.xyz.y;
				float smoothstepResult28 = smoothstep( ( temp_output_13_0 - 0.5 ) , ( temp_output_13_0 + 0.5 ) , vpY9);
				float mask38 = smoothstepResult28;
				float clampResult61 = clamp( pow( ( mask38 * _Const5 ) , 2.5 ) , 0.0 , 1.0 );
				float4 lerpResult67 = lerp( _FirstColor , _SecondColor , clampResult61);
				
				float2 appendResult41 = (float2(0.0 , 0.1));
				float2 appendResult34 = (float2(WorldSpacePosition.x , WorldSpacePosition.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float fresnelNdotV26 = dot( WorldSpaceNormal, WorldSpaceViewDirection );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2D( _Hologram1, panner42 ) * staticSwitch54 );
				float4 screenPos = IN.ase_texcoord8;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth52 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth52 = abs( ( screenDepth52 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthPower ) );
				float clampResult58 = clamp( distanceDepth52 , 0.0 , 1.0 );
				float4 clampResult68 = clamp( ( temp_output_56_0 * clampResult58 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				
				float3 Albedo = float3(0.5, 0.5, 0.5);
				float3 Normal = float3(0, 0, 1);
				float3 Emission = lerpResult67.rgb;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = 0.5;
				float Occlusion = 1;
				float Alpha = clampResult68.r;
				float AlphaClipThreshold = 0.5;
				float3 BakedGI = 0;

				InputData inputData;
				inputData.positionWS = WorldSpacePosition;

				#ifdef _NORMALMAP
					inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3(WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal)));
				#else
					#if !SHADER_HINT_NICE_QUALITY
						inputData.normalWS = WorldSpaceNormal;
					#else
						inputData.normalWS = normalize(WorldSpaceNormal);
					#endif
				#endif

				inputData.viewDirectionWS = WorldSpaceViewDirection;
				inputData.shadowCoord = IN.shadowCoord;

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif
				
				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma shader_feature _INVERT1_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			sampler2D _Hologram1;
			float _ShaderHologramDisplacement;
			uniform float4 _CameraDepthTexture_TexelSize;
			CBUFFER_START( UnityPerMaterial )
			float _UV;
			float _Scale;
			float _Power;
			float _VertexMovement;
			float _ObjectLow;
			float _ObjectHigh;
			float4 _FirstColor;
			float4 _SecondColor;
			float _Const5;
			float _DepthPower;
			CBUFFER_END


			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			
			float3 _LightDirection;

			VertexOutput ShadowPassVertex( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2Dlod( _Hologram1, float4( panner42, 0, 0.0) ) * staticSwitch54 );
				float temp_output_13_0 = ( 0.0 + (_ObjectLow + (_ShaderHologramDisplacement - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0)) );
				float vpY9 = v.vertex.xyz.y;
				float temp_output_23_0 = ( temp_output_13_0 - vpY9 );
				float clampResult31 = clamp( temp_output_23_0 , 0.0 , temp_output_23_0 );
				float4 appendResult47 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult31 ) , 0.0 , 0.0));
				float smoothstepResult36 = smoothstep( ( temp_output_13_0 - 0.2 ) , ( temp_output_13_0 + 0.2 ) , vpY9);
				float4 vertex57 = ( appendResult47 * smoothstepResult36 );
				float smoothstepResult28 = smoothstep( ( temp_output_13_0 - 0.5 ) , ( temp_output_13_0 + 0.5 ) , vpY9);
				float mask38 = smoothstepResult28;
				float4 lerpResult70 = lerp( ( temp_output_56_0 * _VertexMovement ) , vertex57 , mask38);
				
				o.ase_texcoord7.xyz = ase_worldPos;
				o.ase_texcoord8.xyz = ase_worldNormal;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord9 = screenPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.w = 0;
				o.ase_texcoord8.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = lerpResult70.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				o.clipPos = clipPos;

				return o;
			}

			half4 ShadowPassFragment(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );

				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = IN.ase_texcoord7.xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = IN.ase_texcoord8.xyz;
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2D( _Hologram1, panner42 ) * staticSwitch54 );
				float4 screenPos = IN.ase_texcoord9;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth52 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth52 = abs( ( screenDepth52 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthPower ) );
				float clampResult58 = clamp( distanceDepth52 , 0.0 , 1.0 );
				float4 clampResult68 = clamp( ( temp_output_56_0 * clampResult58 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				
				float Alpha = clampResult68.r;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma shader_feature _INVERT1_ON


			sampler2D _Hologram1;
			float _ShaderHologramDisplacement;
			uniform float4 _CameraDepthTexture_TexelSize;
			CBUFFER_START( UnityPerMaterial )
			float _UV;
			float _Scale;
			float _Power;
			float _VertexMovement;
			float _ObjectLow;
			float _ObjectHigh;
			float4 _FirstColor;
			float4 _SecondColor;
			float _Const5;
			float _DepthPower;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2Dlod( _Hologram1, float4( panner42, 0, 0.0) ) * staticSwitch54 );
				float temp_output_13_0 = ( 0.0 + (_ObjectLow + (_ShaderHologramDisplacement - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0)) );
				float vpY9 = v.vertex.xyz.y;
				float temp_output_23_0 = ( temp_output_13_0 - vpY9 );
				float clampResult31 = clamp( temp_output_23_0 , 0.0 , temp_output_23_0 );
				float4 appendResult47 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult31 ) , 0.0 , 0.0));
				float smoothstepResult36 = smoothstep( ( temp_output_13_0 - 0.2 ) , ( temp_output_13_0 + 0.2 ) , vpY9);
				float4 vertex57 = ( appendResult47 * smoothstepResult36 );
				float smoothstepResult28 = smoothstep( ( temp_output_13_0 - 0.5 ) , ( temp_output_13_0 + 0.5 ) , vpY9);
				float mask38 = smoothstepResult28;
				float4 lerpResult70 = lerp( ( temp_output_56_0 * _VertexMovement ) , vertex57 , mask38);
				
				o.ase_texcoord.xyz = ase_worldPos;
				o.ase_texcoord1.xyz = ase_worldNormal;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = lerpResult70.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = IN.ase_texcoord.xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = IN.ase_texcoord1.xyz;
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2D( _Hologram1, panner42 ) * staticSwitch54 );
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth52 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth52 = abs( ( screenDepth52 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthPower ) );
				float clampResult58 = clamp( distanceDepth52 , 0.0 , 1.0 );
				float4 clampResult68 = clamp( ( temp_output_56_0 * clampResult58 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				
				float Alpha = clampResult68.r;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#pragma shader_feature _INVERT1_ON


			sampler2D _Hologram1;
			float _ShaderHologramDisplacement;
			uniform float4 _CameraDepthTexture_TexelSize;
			CBUFFER_START( UnityPerMaterial )
			float _UV;
			float _Scale;
			float _Power;
			float _VertexMovement;
			float _ObjectLow;
			float _ObjectHigh;
			float4 _FirstColor;
			float4 _SecondColor;
			float _Const5;
			float _DepthPower;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2Dlod( _Hologram1, float4( panner42, 0, 0.0) ) * staticSwitch54 );
				float temp_output_13_0 = ( 0.0 + (_ObjectLow + (_ShaderHologramDisplacement - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0)) );
				float vpY9 = v.vertex.xyz.y;
				float temp_output_23_0 = ( temp_output_13_0 - vpY9 );
				float clampResult31 = clamp( temp_output_23_0 , 0.0 , temp_output_23_0 );
				float4 appendResult47 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult31 ) , 0.0 , 0.0));
				float smoothstepResult36 = smoothstep( ( temp_output_13_0 - 0.2 ) , ( temp_output_13_0 + 0.2 ) , vpY9);
				float4 vertex57 = ( appendResult47 * smoothstepResult36 );
				float smoothstepResult28 = smoothstep( ( temp_output_13_0 - 0.5 ) , ( temp_output_13_0 + 0.5 ) , vpY9);
				float mask38 = smoothstepResult28;
				float4 lerpResult70 = lerp( ( temp_output_56_0 * _VertexMovement ) , vertex57 , mask38);
				
				o.ase_texcoord1.xyz = ase_worldPos;
				o.ase_texcoord2.xyz = ase_worldNormal;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = lerpResult70.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float temp_output_13_0 = ( 0.0 + (_ObjectLow + (_ShaderHologramDisplacement - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0)) );
				float vpY9 = IN.ase_texcoord.xyz.y;
				float smoothstepResult28 = smoothstep( ( temp_output_13_0 - 0.5 ) , ( temp_output_13_0 + 0.5 ) , vpY9);
				float mask38 = smoothstepResult28;
				float clampResult61 = clamp( pow( ( mask38 * _Const5 ) , 2.5 ) , 0.0 , 1.0 );
				float4 lerpResult67 = lerp( _FirstColor , _SecondColor , clampResult61);
				
				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = IN.ase_texcoord1.xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2D( _Hologram1, panner42 ) * staticSwitch54 );
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth52 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth52 = abs( ( screenDepth52 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthPower ) );
				float clampResult58 = clamp( distanceDepth52 , 0.0 , 1.0 );
				float4 clampResult68 = clamp( ( temp_output_56_0 * clampResult58 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				
				
				float3 Albedo = float3(0.5, 0.5, 0.5);
				float3 Emission = lerpResult67.rgb;
				float Alpha = clampResult68.r;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha , One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma enable_d3d11_debug_symbols
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#pragma shader_feature _INVERT1_ON


			sampler2D _Hologram1;
			float _ShaderHologramDisplacement;
			uniform float4 _CameraDepthTexture_TexelSize;
			CBUFFER_START( UnityPerMaterial )
			float _UV;
			float _Scale;
			float _Power;
			float _VertexMovement;
			float _ObjectLow;
			float _ObjectHigh;
			float4 _FirstColor;
			float4 _SecondColor;
			float _Const5;
			float _DepthPower;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2Dlod( _Hologram1, float4( panner42, 0, 0.0) ) * staticSwitch54 );
				float temp_output_13_0 = ( 0.0 + (_ObjectLow + (_ShaderHologramDisplacement - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0)) );
				float vpY9 = v.vertex.xyz.y;
				float temp_output_23_0 = ( temp_output_13_0 - vpY9 );
				float clampResult31 = clamp( temp_output_23_0 , 0.0 , temp_output_23_0 );
				float4 appendResult47 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult31 ) , 0.0 , 0.0));
				float smoothstepResult36 = smoothstep( ( temp_output_13_0 - 0.2 ) , ( temp_output_13_0 + 0.2 ) , vpY9);
				float4 vertex57 = ( appendResult47 * smoothstepResult36 );
				float smoothstepResult28 = smoothstep( ( temp_output_13_0 - 0.5 ) , ( temp_output_13_0 + 0.5 ) , vpY9);
				float mask38 = smoothstepResult28;
				float4 lerpResult70 = lerp( ( temp_output_56_0 * _VertexMovement ) , vertex57 , mask38);
				
				o.ase_texcoord.xyz = ase_worldPos;
				o.ase_texcoord1.xyz = ase_worldNormal;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = lerpResult70.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.vertex.xyz );
				o.clipPos = vertexInput.positionCS;
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				float2 appendResult41 = (float2(0.0 , 0.1));
				float3 ase_worldPos = IN.ase_texcoord.xyz;
				float2 appendResult34 = (float2(ase_worldPos.x , ase_worldPos.y));
				float2 panner42 = ( 1.0 * _Time.y * appendResult41 + ( appendResult34 * _UV ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = IN.ase_texcoord1.xyz;
				float fresnelNdotV26 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode26 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV26, _Power ) );
				float clampResult46 = clamp( ( 1.0 - fresnelNode26 ) , 0.0 , 1.0 );
				#ifdef _INVERT1_ON
				float staticSwitch54 = clampResult46;
				#else
				float staticSwitch54 = fresnelNode26;
				#endif
				float4 temp_output_56_0 = ( tex2D( _Hologram1, panner42 ) * staticSwitch54 );
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth52 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth52 = abs( ( screenDepth52 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthPower ) );
				float clampResult58 = clamp( distanceDepth52 , 0.0 , 1.0 );
				float4 clampResult68 = clamp( ( temp_output_56_0 * clampResult58 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				
				
				float3 Albedo = float3(0.5, 0.5, 0.5);
				float Alpha = clampResult68.r;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}
		
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=17700
88;44;1816;974;2609.152;-151.0092;1.454695;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;5;-2657.938,586.7233;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-2561.268,1361.574;Float;False;Global;_ShaderHologramDisplacement;_ShaderHologramDisplacement;2;0;Create;True;0;0;False;0;0;0.7989241;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2424.718,1523.533;Float;False;Property;_ObjectHigh;ObjectHigh;1;0;Create;True;0;0;False;0;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2438.419,1447.339;Float;False;Property;_ObjectLow;ObjectLow;2;0;Create;True;0;0;False;0;0;-0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-2372.22,626.4613;Float;False;vpY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-2126.844,949.8994;Inherit;False;9;vpY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2150.49,1260.8;Inherit;False;Constant;_Const7;Const6;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;11;-2169.835,1364.306;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;15;-1594.395,1166.885;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1910.389,1340.453;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-2470.564,-293.3679;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;24;-1524.633,1089.903;Float;False;Constant;_Const3;Const2;5;0;Create;True;0;0;False;0;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-1500.832,1191.781;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;25;-1545.877,912.5275;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-2409.425,140.6161;Float;False;Property;_Power;Power;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2411.425,60.61636;Float;False;Property;_Scale;Scale;3;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1937.675,1458.164;Float;False;Constant;_Const2;Const1;5;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2232.694,-68.97053;Float;False;Constant;_Panner1;Panner;5;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2224.702,-167.261;Float;False;Property;_UV;UV;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-2215.58,-269.9814;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;26;-2206.111,53.15701;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;32;-1493.761,1332.102;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-1662.543,1330.486;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1291.924,1010.774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;31;-1289.197,1192.26;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-1643.799,1440.857;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-1099.357,1086.265;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1999.612,-271.8804;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;37;-1937.214,152.1314;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1779.352,705.5233;Float;False;Constant;_Const4;Const3;7;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-1997.814,-152.0644;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-1418.52,1394.107;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1779.729,342.6426;Float;False;Property;_DepthPower;DepthPower;7;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-1488.304,630.2203;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;45;-896.0829,1357.739;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;42;-1803.445,-271.8289;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-916.5949,1064.612;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;16;-1718.486,589.0643;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1491.069,764.7264;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;46;-1746.59,152.9351;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;28;-1172.228,650.8453;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-668.4271,1063.938;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;53;-1566.288,-299.9434;Inherit;True;Property;_Hologram1;Hologram;0;0;Create;True;0;0;False;0;-1;None;6110bf08410df5d41984fa2fdf8db4e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;52;-1560.789,323.221;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;54;-1559.515,49.83144;Float;False;Property;_Invert1;Invert;8;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-968.8985,-174.3388;Float;False;Property;_VertexMovement;VertexMovement;10;0;Create;True;0;0;False;0;0.02;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;58;-1265.802,322.3099;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-910.593,643.7723;Float;False;mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1188.977,-295.2352;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-434.332,1059.994;Float;False;vertex;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-979.0893,-17.39219;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-756.0597,234.1693;Inherit;False;38;mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-797.3809,122.6823;Inherit;False;57;vertex;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-722.813,-293.9633;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1253.405,-683.236;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1463.405,-636.2358;Inherit;False;Property;_Const5;Const4;11;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1264.505,-570.2632;Inherit;False;Constant;_Const6;Const5;12;0;Create;True;0;0;False;0;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;-997.5425,-875.9712;Float;False;Property;_SecondColor;SecondColor;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;6.498019,6.498019,6.498019,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;61;-835.7111,-683.4398;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;-629.2429,-728.0862;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1470.206,-734.3673;Inherit;False;38;mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;55;-1063.345,-685.0917;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;68;-802.0868,-19.29588;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;70;-485.9258,45.4789;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-2373.45,716.2943;Float;False;vpZ;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-2373.427,535.8409;Float;False;vpX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;62;-939.2584,-1059.955;Float;False;Property;_FirstColor;FirstColor;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,1.109601,8.574187,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-115.2436,-318.1373;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;HologramDepthFadeDisplacementURP;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;0;Forward;12;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;12;Workflow;1;Surface;1;  Blend;0;Two Sided;1;Cast Shadows;1;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;Meta Pass;1;Override Baked GI;0;Vertex Position,InvertActionOnDeselection;1;0;5;True;True;True;True;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;4;Universal2D;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;True;True;True;True;True;0;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
WireConnection;9;0;5;2
WireConnection;11;0;7;0
WireConnection;11;3;6;0
WireConnection;11;4;8;0
WireConnection;15;0;12;0
WireConnection;13;0;10;0
WireConnection;13;1;11;0
WireConnection;23;0;13;0
WireConnection;23;1;15;0
WireConnection;34;0;19;1
WireConnection;34;1;19;2
WireConnection;26;2;21;0
WireConnection;26;3;22;0
WireConnection;32;0;12;0
WireConnection;29;0;13;0
WireConnection;29;1;20;0
WireConnection;27;0;25;2
WireConnection;27;1;24;0
WireConnection;31;0;23;0
WireConnection;31;2;23;0
WireConnection;35;0;13;0
WireConnection;35;1;20;0
WireConnection;40;0;27;0
WireConnection;40;1;31;0
WireConnection;39;0;34;0
WireConnection;39;1;33;0
WireConnection;37;0;26;0
WireConnection;41;1;30;0
WireConnection;36;0;32;0
WireConnection;36;1;29;0
WireConnection;36;2;35;0
WireConnection;18;0;13;0
WireConnection;18;1;14;0
WireConnection;45;0;36;0
WireConnection;42;0;39;0
WireConnection;42;2;41;0
WireConnection;47;1;40;0
WireConnection;16;0;12;0
WireConnection;17;0;13;0
WireConnection;17;1;14;0
WireConnection;46;0;37;0
WireConnection;28;0;16;0
WireConnection;28;1;18;0
WireConnection;28;2;17;0
WireConnection;49;0;47;0
WireConnection;49;1;45;0
WireConnection;53;1;42;0
WireConnection;52;0;48;0
WireConnection;54;1;26;0
WireConnection;54;0;46;0
WireConnection;58;0;52;0
WireConnection;38;0;28;0
WireConnection;56;0;53;0
WireConnection;56;1;54;0
WireConnection;57;0;49;0
WireConnection;64;0;56;0
WireConnection;64;1;58;0
WireConnection;63;0;56;0
WireConnection;63;1;59;0
WireConnection;50;0;43;0
WireConnection;50;1;44;0
WireConnection;61;0;55;0
WireConnection;67;0;62;0
WireConnection;67;1;60;0
WireConnection;67;2;61;0
WireConnection;55;0;50;0
WireConnection;55;1;51;0
WireConnection;68;0;64;0
WireConnection;70;0;63;0
WireConnection;70;1;66;0
WireConnection;70;2;65;0
WireConnection;69;0;5;3
WireConnection;71;0;5;1
WireConnection;0;2;67;0
WireConnection;0;6;68;0
WireConnection;0;8;70;0
ASEEND*/
//CHKSM=F220407BCB34899657D5F33B452D2C2D1BF64C38