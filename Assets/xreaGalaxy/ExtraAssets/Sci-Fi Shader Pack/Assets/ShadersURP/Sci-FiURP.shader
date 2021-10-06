// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SciFI_URP/Sci-FiURP"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_AlbedoColor("AlbedoColor", Color) = (0,0,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Normal("Normal", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_Emission("Emission", 2D) = "black" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		[HDR]_VertexColor("VertexColor", Color) = (0,0,0,0)
		_ObjectHigh("ObjectHigh", Float) = 0
		_ObjectLow("ObjectLow", Float) = 0
		_Noises("Noises", 2D) = "white" {}
		_DissolveTiling("DissolveTiling", Float) = 1
		[HDR]_DissolveColor("DissolveColor", Color) = (0.180188,4.594794,0,0)
		_DissolvePower("DissolvePower", Range( 0 , 1)) = 0
		_DissolveColorPower("DissolveColorPower", Float) = 0.02
		_DissolveSquareScale("DissolveSquareScale", Range( 0.01 , 1)) = 0.01
		_DissolveSquarePower("DissolveSquarePower", Range( 0 , 10)) = 1
		[HDR]_FirstTextureColor("FirstTextureColor", Color) = (0,0.07736176,0.8773585,0)
		_FirstTextureHight("FirstTextureHight", Float) = 0
		_FirstTextureScale("FirstTextureScale", Range( 0.1 , 10)) = 0.1
		_FirstTextureTiling("FirstTextureTiling", Float) = 0
		[HDR]_SecondTextureColor("SecondTextureColor", Color) = (0,0.07736176,0.8773585,0)
		_SecondTextureHight("SecondTextureHight", Float) = 0
		_SecondTextureScale("SecondTextureScale", Range( 0.1 , 10)) = 0.1
		_SecondTextureTiling("SecondTextureTiling", Float) = 0
		_DarkAreaScale("DarkAreaScale", Float) = 0
		_DarkAreaPower("DarkAreaPower", Float) = 1
		_OpacityScale("OpacityScale", Range( 0.01 , 0.9)) = 0.01
		_OpacityPower("OpacityPower", Range( 0 , 10)) = 1
		_NormalPower("NormalPower", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 999999

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
			
			

			float _ShaderSciFi;
			sampler2D _Albedo;
			sampler2D _Normal;
			sampler2D _Noises;
			sampler2D _Emission;
			sampler2D _AO;
			CBUFFER_START( UnityPerMaterial )
			float _ObjectLow;
			float _ObjectHigh;
			float4 _Albedo_ST;
			float4 _AlbedoColor;
			float _DarkAreaScale;
			float _DarkAreaPower;
			float _NormalPower;
			float4 _Normal_ST;
			float4 _DissolveColor;
			float _DissolveTiling;
			float _DissolvePower;
			float _DissolveColorPower;
			float4 _VertexColor;
			float _DissolveSquareScale;
			float _DissolveSquarePower;
			float4 _FirstTextureColor;
			float _FirstTextureTiling;
			float _FirstTextureHight;
			float _FirstTextureScale;
			float4 _SecondTextureColor;
			float _SecondTextureTiling;
			float _SecondTextureHight;
			float _SecondTextureScale;
			float4 _Emission_ST;
			float4 _EmissionColor;
			float _Metallic;
			float _Smoothness;
			float4 _AO_ST;
			float _OpacityScale;
			float _OpacityPower;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
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

				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_35_0 = ( -0.3 + temp_output_10_0 );
				float vpY15 = v.vertex.xyz.y;
				float temp_output_89_0 = ( temp_output_35_0 - vpY15 );
				float clampResult105 = clamp( temp_output_89_0 , 0.0 , temp_output_89_0 );
				float4 appendResult122 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult105 ) , 0.0 , 0.0));
				float smoothstepResult108 = smoothstep( ( temp_output_35_0 - 0.2 ) , ( temp_output_35_0 + 0.2 ) , vpY15);
				
				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				o.ase_texcoord8 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( appendResult122 * smoothstepResult108 ).xyz;
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

				float2 uv_Albedo = IN.ase_texcoord7.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 tex2DNode95 = tex2D( _Albedo, uv_Albedo );
				float vpY15 = IN.ase_texcoord8.xyz.y;
				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_14_0 = ( -1.0 * temp_output_10_0 );
				float temp_output_34_0 = ( vpY15 + temp_output_14_0 + 0.4 );
				float clampResult109 = clamp( pow( ( temp_output_34_0 * -1.0 * _DarkAreaScale ) , _DarkAreaPower ) , 0.0 , 1.0 );
				float4 lerpResult116 = lerp( float4( 0,0,0,0 ) , ( tex2DNode95 * _AlbedoColor ) , clampResult109);
				
				float2 uv_Normal = IN.ase_texcoord7.xy * _Normal_ST.xy + _Normal_ST.zw;
				
				float2 temp_cast_1 = (_DissolveTiling).xx;
				float2 uv012 = IN.ase_texcoord7.xy * temp_cast_1 + float2( 0,0 );
				float2 panner16 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv012);
				float temp_output_33_0 = ( 1.0 - tex2D( _Noises, panner16 ).r );
				float temp_output_17_0 = (1.0 + (_DissolvePower - 0.0) * (-0.1 - 1.0) / (1.0 - 0.0));
				float temp_output_35_0 = ( -0.3 + temp_output_10_0 );
				float smoothstepResult52 = smoothstep( ( temp_output_35_0 - 0.5 ) , ( temp_output_35_0 + 0.5 ) , vpY15);
				float4 lerpResult66 = lerp( float4( 0,0,0,0 ) , _VertexColor , smoothstepResult52);
				float clampResult55 = clamp( step( temp_output_33_0 , ( temp_output_17_0 + 0.1 ) ) , 0.0 , 1.0 );
				float clampResult60 = clamp( pow( ( temp_output_34_0 * -1.0 * _DissolveSquareScale ) , _DissolveSquarePower ) , 0.0 , 1.0 );
				float lerpResult68 = lerp( ( 1.0 - clampResult55 ) , 1.0 , clampResult60);
				float4 lerpResult76 = lerp( ( _DissolveColor * ( 1.0 - step( temp_output_33_0 , ( temp_output_17_0 + _DissolveColorPower ) ) ) ) , lerpResult66 , lerpResult68);
				float2 temp_cast_2 = (_FirstTextureTiling).xx;
				float2 uv057 = IN.ase_texcoord7.xy * temp_cast_2 + float2( 0,0 );
				float2 panner64 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv057);
				float4 tex2DNode72 = tex2D( _Noises, panner64 );
				float clampResult71 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _FirstTextureHight ) * -1.0 * _FirstTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult75 = lerp( tex2DNode72.g , 0.0 , clampResult71);
				float4 lerpResult80 = lerp( lerpResult76 , _FirstTextureColor , lerpResult75);
				float2 temp_cast_3 = (_SecondTextureTiling).xx;
				float2 uv050 = IN.ase_texcoord7.xy * temp_cast_3 + float2( 0,0 );
				float2 panner65 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv050);
				float4 tex2DNode69 = tex2D( _Noises, panner65 );
				float clampResult70 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _SecondTextureHight ) * -1.0 * _SecondTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult74 = lerp( tex2DNode69.b , 0.0 , clampResult70);
				float4 lerpResult90 = lerp( lerpResult80 , _SecondTextureColor , lerpResult74);
				float2 uv_Emission = IN.ase_texcoord7.xy * _Emission_ST.xy + _Emission_ST.zw;
				float4 tex2DNode85 = tex2D( _Emission, uv_Emission );
				float4 clampResult112 = clamp( ( tex2DNode85 / lerpResult90 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				float grayscale119 = Luminance(clampResult112.rgb);
				float4 lerpResult131 = lerp( lerpResult90 , ( tex2DNode85 * _EmissionColor ) , grayscale119);
				
				float2 uv_AO = IN.ase_texcoord7.xy * _AO_ST.xy + _AO_ST.zw;
				
				float lerpResult98 = lerp( clampResult55 , 1.0 , clampResult60);
				float lerpResult99 = lerp( tex2DNode72.g , 1.0 , clampResult71);
				float lerpResult97 = lerp( tex2DNode69.b , 1.0 , clampResult70);
				float clampResult111 = clamp( pow( ( temp_output_34_0 * -1.0 * _OpacityScale ) , _OpacityPower ) , 0.0 , 1.0 );
				float lerpResult118 = lerp( ( lerpResult98 * lerpResult99 * lerpResult97 ) , 1.0 , clampResult111);
				
				float3 Albedo = lerpResult116.rgb;
				float3 Normal = UnpackNormalScale( tex2D( _Normal, uv_Normal ), _NormalPower );
				float3 Emission = lerpResult131.rgb;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = _Smoothness;
				float Occlusion = tex2D( _AO, uv_AO ).r;
				float Alpha = ( tex2DNode95.a * lerpResult118 );
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
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			float _ShaderSciFi;
			sampler2D _Albedo;
			sampler2D _Noises;
			CBUFFER_START( UnityPerMaterial )
			float _ObjectLow;
			float _ObjectHigh;
			float4 _Albedo_ST;
			float4 _AlbedoColor;
			float _DarkAreaScale;
			float _DarkAreaPower;
			float _NormalPower;
			float4 _Normal_ST;
			float4 _DissolveColor;
			float _DissolveTiling;
			float _DissolvePower;
			float _DissolveColorPower;
			float4 _VertexColor;
			float _DissolveSquareScale;
			float _DissolveSquarePower;
			float4 _FirstTextureColor;
			float _FirstTextureTiling;
			float _FirstTextureHight;
			float _FirstTextureScale;
			float4 _SecondTextureColor;
			float _SecondTextureTiling;
			float _SecondTextureHight;
			float _SecondTextureScale;
			float4 _Emission_ST;
			float4 _EmissionColor;
			float _Metallic;
			float _Smoothness;
			float4 _AO_ST;
			float _OpacityScale;
			float _OpacityPower;
			CBUFFER_END


			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			
			float3 _LightDirection;

			VertexOutput ShadowPassVertex( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_35_0 = ( -0.3 + temp_output_10_0 );
				float vpY15 = v.vertex.xyz.y;
				float temp_output_89_0 = ( temp_output_35_0 - vpY15 );
				float clampResult105 = clamp( temp_output_89_0 , 0.0 , temp_output_89_0 );
				float4 appendResult122 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult105 ) , 0.0 , 0.0));
				float smoothstepResult108 = smoothstep( ( temp_output_35_0 - 0.2 ) , ( temp_output_35_0 + 0.2 ) , vpY15);
				
				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				o.ase_texcoord8 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( appendResult122 * smoothstepResult108 ).xyz;
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

				float2 uv_Albedo = IN.ase_texcoord7.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 tex2DNode95 = tex2D( _Albedo, uv_Albedo );
				float2 temp_cast_0 = (_DissolveTiling).xx;
				float2 uv012 = IN.ase_texcoord7.xy * temp_cast_0 + float2( 0,0 );
				float2 panner16 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv012);
				float temp_output_33_0 = ( 1.0 - tex2D( _Noises, panner16 ).r );
				float temp_output_17_0 = (1.0 + (_DissolvePower - 0.0) * (-0.1 - 1.0) / (1.0 - 0.0));
				float clampResult55 = clamp( step( temp_output_33_0 , ( temp_output_17_0 + 0.1 ) ) , 0.0 , 1.0 );
				float vpY15 = IN.ase_texcoord8.xyz.y;
				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_14_0 = ( -1.0 * temp_output_10_0 );
				float temp_output_34_0 = ( vpY15 + temp_output_14_0 + 0.4 );
				float clampResult60 = clamp( pow( ( temp_output_34_0 * -1.0 * _DissolveSquareScale ) , _DissolveSquarePower ) , 0.0 , 1.0 );
				float lerpResult98 = lerp( clampResult55 , 1.0 , clampResult60);
				float2 temp_cast_1 = (_FirstTextureTiling).xx;
				float2 uv057 = IN.ase_texcoord7.xy * temp_cast_1 + float2( 0,0 );
				float2 panner64 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv057);
				float4 tex2DNode72 = tex2D( _Noises, panner64 );
				float clampResult71 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _FirstTextureHight ) * -1.0 * _FirstTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult99 = lerp( tex2DNode72.g , 1.0 , clampResult71);
				float2 temp_cast_2 = (_SecondTextureTiling).xx;
				float2 uv050 = IN.ase_texcoord7.xy * temp_cast_2 + float2( 0,0 );
				float2 panner65 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv050);
				float4 tex2DNode69 = tex2D( _Noises, panner65 );
				float clampResult70 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _SecondTextureHight ) * -1.0 * _SecondTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult97 = lerp( tex2DNode69.b , 1.0 , clampResult70);
				float clampResult111 = clamp( pow( ( temp_output_34_0 * -1.0 * _OpacityScale ) , _OpacityPower ) , 0.0 , 1.0 );
				float lerpResult118 = lerp( ( lerpResult98 * lerpResult99 * lerpResult97 ) , 1.0 , clampResult111);
				
				float Alpha = ( tex2DNode95.a * lerpResult118 );
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
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			float _ShaderSciFi;
			sampler2D _Albedo;
			sampler2D _Noises;
			CBUFFER_START( UnityPerMaterial )
			float _ObjectLow;
			float _ObjectHigh;
			float4 _Albedo_ST;
			float4 _AlbedoColor;
			float _DarkAreaScale;
			float _DarkAreaPower;
			float _NormalPower;
			float4 _Normal_ST;
			float4 _DissolveColor;
			float _DissolveTiling;
			float _DissolvePower;
			float _DissolveColorPower;
			float4 _VertexColor;
			float _DissolveSquareScale;
			float _DissolveSquarePower;
			float4 _FirstTextureColor;
			float _FirstTextureTiling;
			float _FirstTextureHight;
			float _FirstTextureScale;
			float4 _SecondTextureColor;
			float _SecondTextureTiling;
			float _SecondTextureHight;
			float _SecondTextureScale;
			float4 _Emission_ST;
			float4 _EmissionColor;
			float _Metallic;
			float _Smoothness;
			float4 _AO_ST;
			float _OpacityScale;
			float _OpacityPower;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_35_0 = ( -0.3 + temp_output_10_0 );
				float vpY15 = v.vertex.xyz.y;
				float temp_output_89_0 = ( temp_output_35_0 - vpY15 );
				float clampResult105 = clamp( temp_output_89_0 , 0.0 , temp_output_89_0 );
				float4 appendResult122 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult105 ) , 0.0 , 0.0));
				float smoothstepResult108 = smoothstep( ( temp_output_35_0 - 0.2 ) , ( temp_output_35_0 + 0.2 ) , vpY15);
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_texcoord1 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( appendResult122 * smoothstepResult108 ).xyz;
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

				float2 uv_Albedo = IN.ase_texcoord.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 tex2DNode95 = tex2D( _Albedo, uv_Albedo );
				float2 temp_cast_0 = (_DissolveTiling).xx;
				float2 uv012 = IN.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 panner16 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv012);
				float temp_output_33_0 = ( 1.0 - tex2D( _Noises, panner16 ).r );
				float temp_output_17_0 = (1.0 + (_DissolvePower - 0.0) * (-0.1 - 1.0) / (1.0 - 0.0));
				float clampResult55 = clamp( step( temp_output_33_0 , ( temp_output_17_0 + 0.1 ) ) , 0.0 , 1.0 );
				float vpY15 = IN.ase_texcoord1.xyz.y;
				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_14_0 = ( -1.0 * temp_output_10_0 );
				float temp_output_34_0 = ( vpY15 + temp_output_14_0 + 0.4 );
				float clampResult60 = clamp( pow( ( temp_output_34_0 * -1.0 * _DissolveSquareScale ) , _DissolveSquarePower ) , 0.0 , 1.0 );
				float lerpResult98 = lerp( clampResult55 , 1.0 , clampResult60);
				float2 temp_cast_1 = (_FirstTextureTiling).xx;
				float2 uv057 = IN.ase_texcoord.xy * temp_cast_1 + float2( 0,0 );
				float2 panner64 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv057);
				float4 tex2DNode72 = tex2D( _Noises, panner64 );
				float clampResult71 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _FirstTextureHight ) * -1.0 * _FirstTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult99 = lerp( tex2DNode72.g , 1.0 , clampResult71);
				float2 temp_cast_2 = (_SecondTextureTiling).xx;
				float2 uv050 = IN.ase_texcoord.xy * temp_cast_2 + float2( 0,0 );
				float2 panner65 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv050);
				float4 tex2DNode69 = tex2D( _Noises, panner65 );
				float clampResult70 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _SecondTextureHight ) * -1.0 * _SecondTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult97 = lerp( tex2DNode69.b , 1.0 , clampResult70);
				float clampResult111 = clamp( pow( ( temp_output_34_0 * -1.0 * _OpacityScale ) , _OpacityPower ) , 0.0 , 1.0 );
				float lerpResult118 = lerp( ( lerpResult98 * lerpResult99 * lerpResult97 ) , 1.0 , clampResult111);
				
				float Alpha = ( tex2DNode95.a * lerpResult118 );
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
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			float _ShaderSciFi;
			sampler2D _Albedo;
			sampler2D _Noises;
			sampler2D _Emission;
			CBUFFER_START( UnityPerMaterial )
			float _ObjectLow;
			float _ObjectHigh;
			float4 _Albedo_ST;
			float4 _AlbedoColor;
			float _DarkAreaScale;
			float _DarkAreaPower;
			float _NormalPower;
			float4 _Normal_ST;
			float4 _DissolveColor;
			float _DissolveTiling;
			float _DissolvePower;
			float _DissolveColorPower;
			float4 _VertexColor;
			float _DissolveSquareScale;
			float _DissolveSquarePower;
			float4 _FirstTextureColor;
			float _FirstTextureTiling;
			float _FirstTextureHight;
			float _FirstTextureScale;
			float4 _SecondTextureColor;
			float _SecondTextureTiling;
			float _SecondTextureHight;
			float _SecondTextureScale;
			float4 _Emission_ST;
			float4 _EmissionColor;
			float _Metallic;
			float _Smoothness;
			float4 _AO_ST;
			float _OpacityScale;
			float _OpacityPower;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_35_0 = ( -0.3 + temp_output_10_0 );
				float vpY15 = v.vertex.xyz.y;
				float temp_output_89_0 = ( temp_output_35_0 - vpY15 );
				float clampResult105 = clamp( temp_output_89_0 , 0.0 , temp_output_89_0 );
				float4 appendResult122 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult105 ) , 0.0 , 0.0));
				float smoothstepResult108 = smoothstep( ( temp_output_35_0 - 0.2 ) , ( temp_output_35_0 + 0.2 ) , vpY15);
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_texcoord1 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( appendResult122 * smoothstepResult108 ).xyz;
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

				float2 uv_Albedo = IN.ase_texcoord.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 tex2DNode95 = tex2D( _Albedo, uv_Albedo );
				float vpY15 = IN.ase_texcoord1.xyz.y;
				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_14_0 = ( -1.0 * temp_output_10_0 );
				float temp_output_34_0 = ( vpY15 + temp_output_14_0 + 0.4 );
				float clampResult109 = clamp( pow( ( temp_output_34_0 * -1.0 * _DarkAreaScale ) , _DarkAreaPower ) , 0.0 , 1.0 );
				float4 lerpResult116 = lerp( float4( 0,0,0,0 ) , ( tex2DNode95 * _AlbedoColor ) , clampResult109);
				
				float2 temp_cast_1 = (_DissolveTiling).xx;
				float2 uv012 = IN.ase_texcoord.xy * temp_cast_1 + float2( 0,0 );
				float2 panner16 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv012);
				float temp_output_33_0 = ( 1.0 - tex2D( _Noises, panner16 ).r );
				float temp_output_17_0 = (1.0 + (_DissolvePower - 0.0) * (-0.1 - 1.0) / (1.0 - 0.0));
				float temp_output_35_0 = ( -0.3 + temp_output_10_0 );
				float smoothstepResult52 = smoothstep( ( temp_output_35_0 - 0.5 ) , ( temp_output_35_0 + 0.5 ) , vpY15);
				float4 lerpResult66 = lerp( float4( 0,0,0,0 ) , _VertexColor , smoothstepResult52);
				float clampResult55 = clamp( step( temp_output_33_0 , ( temp_output_17_0 + 0.1 ) ) , 0.0 , 1.0 );
				float clampResult60 = clamp( pow( ( temp_output_34_0 * -1.0 * _DissolveSquareScale ) , _DissolveSquarePower ) , 0.0 , 1.0 );
				float lerpResult68 = lerp( ( 1.0 - clampResult55 ) , 1.0 , clampResult60);
				float4 lerpResult76 = lerp( ( _DissolveColor * ( 1.0 - step( temp_output_33_0 , ( temp_output_17_0 + _DissolveColorPower ) ) ) ) , lerpResult66 , lerpResult68);
				float2 temp_cast_2 = (_FirstTextureTiling).xx;
				float2 uv057 = IN.ase_texcoord.xy * temp_cast_2 + float2( 0,0 );
				float2 panner64 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv057);
				float4 tex2DNode72 = tex2D( _Noises, panner64 );
				float clampResult71 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _FirstTextureHight ) * -1.0 * _FirstTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult75 = lerp( tex2DNode72.g , 0.0 , clampResult71);
				float4 lerpResult80 = lerp( lerpResult76 , _FirstTextureColor , lerpResult75);
				float2 temp_cast_3 = (_SecondTextureTiling).xx;
				float2 uv050 = IN.ase_texcoord.xy * temp_cast_3 + float2( 0,0 );
				float2 panner65 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv050);
				float4 tex2DNode69 = tex2D( _Noises, panner65 );
				float clampResult70 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _SecondTextureHight ) * -1.0 * _SecondTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult74 = lerp( tex2DNode69.b , 0.0 , clampResult70);
				float4 lerpResult90 = lerp( lerpResult80 , _SecondTextureColor , lerpResult74);
				float2 uv_Emission = IN.ase_texcoord.xy * _Emission_ST.xy + _Emission_ST.zw;
				float4 tex2DNode85 = tex2D( _Emission, uv_Emission );
				float4 clampResult112 = clamp( ( tex2DNode85 / lerpResult90 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				float grayscale119 = Luminance(clampResult112.rgb);
				float4 lerpResult131 = lerp( lerpResult90 , ( tex2DNode85 * _EmissionColor ) , grayscale119);
				
				float lerpResult98 = lerp( clampResult55 , 1.0 , clampResult60);
				float lerpResult99 = lerp( tex2DNode72.g , 1.0 , clampResult71);
				float lerpResult97 = lerp( tex2DNode69.b , 1.0 , clampResult70);
				float clampResult111 = clamp( pow( ( temp_output_34_0 * -1.0 * _OpacityScale ) , _OpacityPower ) , 0.0 , 1.0 );
				float lerpResult118 = lerp( ( lerpResult98 * lerpResult99 * lerpResult97 ) , 1.0 , clampResult111);
				
				
				float3 Albedo = lerpResult116.rgb;
				float3 Emission = lerpResult131.rgb;
				float Alpha = ( tex2DNode95.a * lerpResult118 );
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
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 999999

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
			
			

			float _ShaderSciFi;
			sampler2D _Albedo;
			sampler2D _Noises;
			CBUFFER_START( UnityPerMaterial )
			float _ObjectLow;
			float _ObjectHigh;
			float4 _Albedo_ST;
			float4 _AlbedoColor;
			float _DarkAreaScale;
			float _DarkAreaPower;
			float _NormalPower;
			float4 _Normal_ST;
			float4 _DissolveColor;
			float _DissolveTiling;
			float _DissolvePower;
			float _DissolveColorPower;
			float4 _VertexColor;
			float _DissolveSquareScale;
			float _DissolveSquarePower;
			float4 _FirstTextureColor;
			float _FirstTextureTiling;
			float _FirstTextureHight;
			float _FirstTextureScale;
			float4 _SecondTextureColor;
			float _SecondTextureTiling;
			float _SecondTextureHight;
			float _SecondTextureScale;
			float4 _Emission_ST;
			float4 _EmissionColor;
			float _Metallic;
			float _Smoothness;
			float4 _AO_ST;
			float _OpacityScale;
			float _OpacityPower;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_35_0 = ( -0.3 + temp_output_10_0 );
				float vpY15 = v.vertex.xyz.y;
				float temp_output_89_0 = ( temp_output_35_0 - vpY15 );
				float clampResult105 = clamp( temp_output_89_0 , 0.0 , temp_output_89_0 );
				float4 appendResult122 = (float4(0.0 , ( ( v.ase_normal.y * 0.02 ) + clampResult105 ) , 0.0 , 0.0));
				float smoothstepResult108 = smoothstep( ( temp_output_35_0 - 0.2 ) , ( temp_output_35_0 + 0.2 ) , vpY15);
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_texcoord1 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( appendResult122 * smoothstepResult108 ).xyz;
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
				float2 uv_Albedo = IN.ase_texcoord.xy * _Albedo_ST.xy + _Albedo_ST.zw;
				float4 tex2DNode95 = tex2D( _Albedo, uv_Albedo );
				float vpY15 = IN.ase_texcoord1.xyz.y;
				float temp_output_10_0 = (_ObjectLow + (_ShaderSciFi - 0.0) * (_ObjectHigh - _ObjectLow) / (1.0 - 0.0));
				float temp_output_14_0 = ( -1.0 * temp_output_10_0 );
				float temp_output_34_0 = ( vpY15 + temp_output_14_0 + 0.4 );
				float clampResult109 = clamp( pow( ( temp_output_34_0 * -1.0 * _DarkAreaScale ) , _DarkAreaPower ) , 0.0 , 1.0 );
				float4 lerpResult116 = lerp( float4( 0,0,0,0 ) , ( tex2DNode95 * _AlbedoColor ) , clampResult109);
				
				float2 temp_cast_1 = (_DissolveTiling).xx;
				float2 uv012 = IN.ase_texcoord.xy * temp_cast_1 + float2( 0,0 );
				float2 panner16 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv012);
				float temp_output_33_0 = ( 1.0 - tex2D( _Noises, panner16 ).r );
				float temp_output_17_0 = (1.0 + (_DissolvePower - 0.0) * (-0.1 - 1.0) / (1.0 - 0.0));
				float clampResult55 = clamp( step( temp_output_33_0 , ( temp_output_17_0 + 0.1 ) ) , 0.0 , 1.0 );
				float clampResult60 = clamp( pow( ( temp_output_34_0 * -1.0 * _DissolveSquareScale ) , _DissolveSquarePower ) , 0.0 , 1.0 );
				float lerpResult98 = lerp( clampResult55 , 1.0 , clampResult60);
				float2 temp_cast_2 = (_FirstTextureTiling).xx;
				float2 uv057 = IN.ase_texcoord.xy * temp_cast_2 + float2( 0,0 );
				float2 panner64 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv057);
				float4 tex2DNode72 = tex2D( _Noises, panner64 );
				float clampResult71 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _FirstTextureHight ) * -1.0 * _FirstTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult99 = lerp( tex2DNode72.g , 1.0 , clampResult71);
				float2 temp_cast_3 = (_SecondTextureTiling).xx;
				float2 uv050 = IN.ase_texcoord.xy * temp_cast_3 + float2( 0,0 );
				float2 panner65 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + uv050);
				float4 tex2DNode69 = tex2D( _Noises, panner65 );
				float clampResult70 = clamp( abs( ( ( vpY15 + temp_output_14_0 + _SecondTextureHight ) * -1.0 * _SecondTextureScale ) ) , 0.0 , 1.0 );
				float lerpResult97 = lerp( tex2DNode69.b , 1.0 , clampResult70);
				float clampResult111 = clamp( pow( ( temp_output_34_0 * -1.0 * _OpacityScale ) , _OpacityPower ) , 0.0 , 1.0 );
				float lerpResult118 = lerp( ( lerpResult98 * lerpResult99 * lerpResult97 ) , 1.0 , clampResult111);
				
				
				float3 Albedo = lerpResult116.rgb;
				float Alpha = ( tex2DNode95.a * lerpResult118 );
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
88;44;1816;974;3574.542;-1382.944;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-4214.336,1070.296;Float;False;Property;_ObjectLow;ObjectLow;10;0;Create;True;0;0;False;0;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-4215.532,1152.491;Float;False;Property;_ObjectHigh;ObjectHigh;9;0;Create;True;0;0;False;0;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-4328.086,987.5321;Float;False;Global;_ShaderSciFi;_ShaderSciFi;9;0;Create;True;0;0;False;0;0;1.056091;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-4263.804,-1462.002;Float;False;Property;_DissolveTiling;DissolveTiling;12;0;Create;True;0;0;False;0;1;18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3833.942,-94.18207;Float;False;Constant;_Const4;Const4;12;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;10;-3980.3,988.9054;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;9;-4059.067,1703.814;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-3642.129,-89.93915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-4004.467,-1479.201;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-3773.352,1743.552;Float;False;vpY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;16;-3721.499,-1477.934;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;26;-3274.286,359.6456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-3069.12,375.3898;Inherit;False;15;vpY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3307.342,-519.535;Float;False;Constant;_Const6;Const6;16;0;Create;True;0;0;False;0;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3130.641,6.368948;Float;False;Property;_FirstTextureHight;FirstTextureHight;19;0;Create;True;0;0;False;0;0;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-3112.146,536.9086;Float;False;Property;_SecondTextureHight;SecondTextureHight;23;0;Create;True;0;0;False;0;0;1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-3112.369,-131.8981;Inherit;False;15;vpY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-3302.454,-660.847;Inherit;False;15;vpY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;18;-3409.113,-509.42;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3942.486,-1221.178;Float;False;Property;_DissolvePower;DissolvePower;14;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-3157.373,-462.0749;Float;False;Property;_DissolveSquareScale;DissolveSquareScale;16;0;Create;True;0;0;False;0;0.01;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-3054.912,186.049;Float;False;Property;_SecondTextureTiling;SecondTextureTiling;25;0;Create;True;0;0;False;0;0;24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2840.035,578.1942;Float;False;Property;_SecondTextureScale;SecondTextureScale;24;0;Create;True;0;0;False;0;0.1;2.55;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-3417.571,-1101.387;Float;False;Constant;_OpacityPowerConst;OpacityPowerConst;10;0;Create;True;0;0;False;0;0.1;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2918.371,-317.5091;Float;False;Property;_FirstTextureTiling;FirstTextureTiling;21;0;Create;True;0;0;False;0;0;14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;17;-3596.457,-1215.971;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-3502.226,-1506.941;Inherit;True;Property;_Noises;Noises;11;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-3070.328,-630.833;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-2820.215,-100.9559;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-2810.719,426.5839;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2849.53,50.65435;Float;False;Property;_FirstTextureScale;FirstTextureScale;20;0;Create;True;0;0;False;0;0.1;1.7;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3650.624,1378.757;Float;False;Constant;_Const8;Const8;27;0;Create;True;0;0;False;0;-0.3;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2581.484,426.555;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-2551.355,-100.985;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-2757.582,169.0887;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-3113.008,-1168.132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2842.253,-631.598;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-3171.457,-1480.223;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2851.868,-462.4029;Float;False;Property;_DissolveSquarePower;DissolveSquarePower;17;0;Create;True;0;0;False;0;1;0.84;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-2658.672,-335.125;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;82;-3005.218,-889.55;Float;False;Property;_DarkAreaScale;DarkAreaScale;26;0;Create;True;0;0;False;0;0;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-2804.833,789.0802;Float;False;Property;_OpacityScale;OpacityScale;28;0;Create;True;0;0;False;0;0.01;0.14;0.01;0.9;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-3390.324,1385.306;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;58;-2315.515,425.5444;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;38;-2900.083,-1190.119;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2987.075,1654.725;Inherit;False;15;vpY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;65;-2477.323,170.8485;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;51;-2607.721,-631.416;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;64;-2388.408,-335.068;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;61;-2297.098,-100.9799;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;71;-2061.726,-99.91516;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-2747.354,-780.256;Float;False;Property;_DarkAreaPower;DarkAreaPower;27;0;Create;True;0;0;False;0;1;3.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;70;-2068.755,425.2245;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;88;-2768.172,1373.126;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;69;-2250.733,144.3781;Inherit;True;Property;_SecondTexture;SecondTexture;11;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Instance;21;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;-2746.927,1528.5;Float;False;Constant;_Const2;Const2;5;0;Create;True;0;0;False;0;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-3162.569,1896.763;Float;False;Constant;_Const1;Const1;5;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;55;-2683.673,-1188.714;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-2717.127,-930.5552;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;89;-2725.726,1630.38;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-2437.746,641.7085;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;-2150.098,-359.8631;Inherit;True;Property;_FirstTexture;FirstTexture;11;0;Create;True;0;0;False;0;-1;None;abd11bfa9bc2b804299d5eb4f1e04fd3;True;0;False;white;Auto;False;Instance;21;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;60;-2386.342,-631.754;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-2487.603,801.8925;Float;False;Property;_OpacityPower;OpacityPower;29;0;Create;True;0;0;False;0;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;95;-2032.264,-1554.254;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;-1;None;4c5ce12b1194b8f46aced7f71b1c5154;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;106;-1991.326,-1364.2;Float;False;Property;_AlbedoColor;AlbedoColor;1;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;105;-2514.091,1630.858;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;97;-1785.882,376.175;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-2510.817,1464.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;101;-2708.167,1810.56;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;96;-2887.438,1769.085;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;100;-2203.214,641.8905;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-2868.692,1879.456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;94;-2520.558,-930.374;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;98;-2101.854,-814.839;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;99;-1736.857,-147.33;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;109;-2312.363,-931.03;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;111;-1981.835,641.5525;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-1651.025,-1319.04;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;-2324.251,1524.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-1302.479,77.08941;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;108;-2643.414,1832.706;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;120;-2120.977,1796.338;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;116;-1443.218,-1267.886;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;122;-2141.489,1503.21;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;118;-908.3033,176.7354;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;-1218.882,-455.889;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;110;-1012.014,-901.217;Inherit;False;Property;_EmissionColor;EmissionColor;7;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;85;-1177.925,-716.2061;Inherit;True;Property;_Emission;Emission;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;63;-2724.906,-1541.548;Float;False;Property;_DissolveColor;DissolveColor;13;1;[HDR];Create;True;0;0;False;0;0.180188,4.594794,0,0;0,0.04705882,2.996078,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;130;-931.4219,-213.318;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-1456.755,-1119.155;Inherit;False;Property;_NormalPower;NormalPower;30;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;117;-1241.007,-1124.456;Inherit;True;Property;_Normal;Normal;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;56;-2385.029,974.6772;Float;False;Property;_VertexColor;VertexColor;8;1;[HDR];Create;True;0;0;False;0;0,0,0,0;6.498019,5.55517,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;76;-1494.314,-788.403;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;112;-686.1871,-437.8359;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;133;-542.8556,-954.592;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-2713.199,1068.82;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1893.321,1502.537;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-3774.559,1652.932;Float;False;vpX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;68;-2096.491,-1090.131;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;119;-529.6533,-350.985;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3434.961,-1306.914;Float;False;Property;_DissolveColorPower;DissolveColorPower;15;0;Create;True;0;0;False;0;0.02;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;90;-1011.751,-335.0511;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-695.8846,-599.406;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-3073.36,1137.206;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;-1512.979,-515.7581;Float;False;Property;_FirstTextureColor;FirstTextureColor;18;1;[HDR];Create;True;0;0;False;0;0,0.07736176,0.8773585,0;0,0.07736176,0.8773585,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2749.472,967.9791;Inherit;False;15;vpY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;53;-2819.415,-1326.721;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;134;-550.2748,-840.7963;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-926.4633,-129.582;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0;0.568;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-3123.625,-1298.231;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;67;-1608.883,598.1638;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2317.941,-1345.97;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;81;-1151.983,-118.8544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;-2428.216,-1187.896;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-2598.377,-1325.062;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-3774.582,1833.385;Float;False;vpZ;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;102;-843.3778,-481.783;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;52;-2367.906,1164.571;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;74;-1783.626,220.9388;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;66;-2052.699,1114.761;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;131;-319.8734,-273.0241;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-438.4314,72.08562;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-2710.962,1203.325;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;75;-1742.845,-306.7021;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-1331.248,-316.64;Float;False;Property;_SecondTextureColor;SecondTextureColor;22;1;[HDR];Create;True;0;0;False;0;0,0.07736176,0.8773585,0;0,0.07736176,0.8773585,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;129;-939.7904,-51.4753;Inherit;True;Property;_AO;AO;5;0;Create;True;0;0;False;0;-1;None;2afc0435958480243ad7946d47561f95;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;41.67286,-200.7874;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;SciFI_URP/Sci-FiURP;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;0;Forward;12;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;12;Workflow;1;Surface;1;  Blend;0;Two Sided;1;Cast Shadows;1;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;Meta Pass;1;Override Baked GI;0;Vertex Position,InvertActionOnDeselection;1;0;5;True;True;True;True;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;4;Universal2D;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;True;True;True;True;True;0;False;-1;False;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
WireConnection;10;0;7;0
WireConnection;10;3;5;0
WireConnection;10;4;8;0
WireConnection;14;0;11;0
WireConnection;14;1;10;0
WireConnection;12;0;6;0
WireConnection;15;0;9;2
WireConnection;16;0;12;0
WireConnection;26;0;14;0
WireConnection;18;0;14;0
WireConnection;17;0;13;0
WireConnection;21;1;16;0
WireConnection;34;0;20;0
WireConnection;34;1;18;0
WireConnection;34;2;22;0
WireConnection;43;0;32;0
WireConnection;43;1;14;0
WireConnection;43;2;24;0
WireConnection;37;0;27;0
WireConnection;37;1;26;0
WireConnection;37;2;28;0
WireConnection;54;0;37;0
WireConnection;54;2;46;0
WireConnection;49;0;43;0
WireConnection;49;2;47;0
WireConnection;50;0;41;0
WireConnection;31;0;17;0
WireConnection;31;1;23;0
WireConnection;40;0;34;0
WireConnection;40;2;30;0
WireConnection;33;0;21;1
WireConnection;57;0;36;0
WireConnection;35;0;19;0
WireConnection;35;1;10;0
WireConnection;58;0;54;0
WireConnection;38;0;33;0
WireConnection;38;1;31;0
WireConnection;65;0;50;0
WireConnection;51;0;40;0
WireConnection;51;1;45;0
WireConnection;64;0;57;0
WireConnection;61;0;49;0
WireConnection;71;0;61;0
WireConnection;70;0;58;0
WireConnection;69;1;65;0
WireConnection;55;0;38;0
WireConnection;87;0;34;0
WireConnection;87;2;82;0
WireConnection;89;0;35;0
WireConnection;89;1;78;0
WireConnection;93;0;34;0
WireConnection;93;2;83;0
WireConnection;72;1;64;0
WireConnection;60;0;51;0
WireConnection;105;0;89;0
WireConnection;105;2;89;0
WireConnection;97;0;69;3
WireConnection;97;2;70;0
WireConnection;104;0;88;2
WireConnection;104;1;86;0
WireConnection;101;0;78;0
WireConnection;96;0;35;0
WireConnection;96;1;92;0
WireConnection;100;0;93;0
WireConnection;100;1;84;0
WireConnection;103;0;35;0
WireConnection;103;1;92;0
WireConnection;94;0;87;0
WireConnection;94;1;91;0
WireConnection;98;0;55;0
WireConnection;98;2;60;0
WireConnection;99;0;72;2
WireConnection;99;2;71;0
WireConnection;109;0;94;0
WireConnection;111;0;100;0
WireConnection;115;0;95;0
WireConnection;115;1;106;0
WireConnection;114;0;104;0
WireConnection;114;1;105;0
WireConnection;113;0;98;0
WireConnection;113;1;99;0
WireConnection;113;2;97;0
WireConnection;108;0;101;0
WireConnection;108;1;96;0
WireConnection;108;2;103;0
WireConnection;120;0;108;0
WireConnection;116;1;115;0
WireConnection;116;2;109;0
WireConnection;122;1;114;0
WireConnection;118;0;113;0
WireConnection;118;2;111;0
WireConnection;80;0;76;0
WireConnection;80;1;77;0
WireConnection;80;2;75;0
WireConnection;117;5;107;0
WireConnection;76;0;73;0
WireConnection;76;1;67;0
WireConnection;76;2;68;0
WireConnection;112;0;102;0
WireConnection;133;0;116;0
WireConnection;39;0;35;0
WireConnection;39;1;29;0
WireConnection;127;0;122;0
WireConnection;127;1;120;0
WireConnection;125;0;9;1
WireConnection;68;0;62;0
WireConnection;68;2;60;0
WireConnection;119;0;112;0
WireConnection;90;0;80;0
WireConnection;90;1;79;0
WireConnection;90;2;81;0
WireConnection;121;0;85;0
WireConnection;121;1;110;0
WireConnection;53;0;33;0
WireConnection;53;1;48;0
WireConnection;134;0;117;0
WireConnection;48;0;17;0
WireConnection;48;1;25;0
WireConnection;67;0;66;0
WireConnection;73;0;63;0
WireConnection;73;1;59;0
WireConnection;81;0;74;0
WireConnection;62;0;55;0
WireConnection;59;0;53;0
WireConnection;126;0;9;3
WireConnection;102;0;85;0
WireConnection;102;1;90;0
WireConnection;52;0;42;0
WireConnection;52;1;39;0
WireConnection;52;2;44;0
WireConnection;74;0;69;3
WireConnection;74;2;70;0
WireConnection;66;1;56;0
WireConnection;66;2;52;0
WireConnection;131;0;90;0
WireConnection;131;1;121;0
WireConnection;131;2;119;0
WireConnection;128;0;95;4
WireConnection;128;1;118;0
WireConnection;44;0;35;0
WireConnection;44;1;29;0
WireConnection;75;0;72;2
WireConnection;75;2;71;0
WireConnection;0;0;133;0
WireConnection;0;1;134;0
WireConnection;0;2;131;0
WireConnection;0;3;130;0
WireConnection;0;4;132;0
WireConnection;0;5;129;0
WireConnection;0;6;128;0
WireConnection;0;8;127;0
ASEEND*/
//CHKSM=E63ECFEF4E7DD0A4845C496FCC0D0C6C2CF7B975