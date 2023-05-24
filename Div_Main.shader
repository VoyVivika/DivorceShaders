// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VoyVivika/DivorceShaders/Divorce Main"
{
	Properties
	{
		[Enum(Standard,0,Flat,1)]_LightingType("Lighting Type", Float) = 0
		[Header(Flat Light Settings)]_MaxFlatLightDistance("Max Flat Light Distance", Float) = 8
		_FlatLightStrength("Flat Light Strength", Range( 0 , 1)) = 1
		_Albedo("Albedo", 2D) = "black" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_MultiMap("MultiMap", 2D) = "black" {}
		[ToggleUI]_EnableAudioLink("Enable AudioLink", Range( 0 , 1)) = 0
		_AL_Mask("AL_Mask", 2D) = "black" {}
		_ALTimeScale("AL Time Scale", Float) = 0
		_Emission("Emission", 2D) = "black" {}
		_EmissionStrength("Emission Strength", Range( 0 , 1)) = 0
		[ToggleUI]_EnableRimLighting("Enable Rim Lighting", Range( 0 , 1)) = 1
		_RimNormalMap("Rim Normal Map", 2D) = "bump" {}
		_RimPower("Rim Power", Range( 0 , 10)) = 2.07
		_RimEnergy("Rim Energy", Range( 0 , 1)) = 0.345
		_RimBaseColorStrength("Rim Base Color Strength", Range( 0 , 1)) = 1
		[Header(UV Tile Discard)][ToggleUI]_DiscardUVTile00("Discard UV Tile 0,0", Range( 0 , 1)) = 0
		[ToggleUI]_DiscardUVTile01("Discard UV Tile 0,1", Float) = 0
		[ToggleUI]_DiscardUVTile02("Discard UV Tile 0,2", Float) = 0
		[ToggleUI]_DiscardUVTile03("Discard UV Tile 0,3", Float) = 0
		[ToggleUI]_DiscardUVTile10("Discard UV Tile 1,0", Float) = 0
		[ToggleUI]_DiscardUVTile11("Discard UV Tile 1,1", Float) = 0
		[ToggleUI]_DiscardUVTile12("Discard UV Tile 1,2", Float) = 0
		[ToggleUI]_DiscardUVTile13("Discard UV Tile 1,3", Float) = 0
		[ToggleUI]_DiscardUVTile20("Discard UV Tile 2,0", Float) = 0
		[ToggleUI]_DiscardUVTile21("Discard UV Tile 2,1", Float) = 0
		[ToggleUI]_DiscardUVTile22("Discard UV Tile 2,2", Float) = 0
		[ToggleUI]_DiscardUVTile23("Discard UV Tile 2,3", Float) = 0
		[ToggleUI]_DiscardUVTile30("Discard UV Tile 3,0", Float) = 0
		[ToggleUI]_DiscardUVTile31("Discard UV Tile 3,1", Float) = 0
		[ToggleUI]_DiscardUVTile32("Discard UV Tile 3,2", Float) = 0
		[ToggleUI]_DiscardUVTile33("Discard UV Tile 3,3", Float) = 0
		[Header(UV Range Discard)][Header(X and Y are Start UVs)][Header(Z and W are End UVs)][ToggleUI]_UVRangeDiscard1("UV Range Discard 1", Range( 0 , 1)) = 0
		_UVRangeDiscard1Range("UV Range Discard 1 Range", Vector) = (0,0,1,1)
		[ToggleUI]_UVRangeDiscard2("UV Range Discard 2", Float) = 0
		_UVRangeDiscard2Range("UV Range Discard 2 Range", Vector) = (0,0,1,1)
		[ToggleUI]_UVRangeDiscard3("UV Range Discard 3", Float) = 0
		_UVRangeDiscard3Range("UV Range Discard 3 Range", Vector) = (0,0,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#include "Assets/AudioLink/Shaders/AudioLink.cginc"
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _UVRangeDiscard1;
		uniform float4 _UVRangeDiscard1Range;
		uniform float _UVRangeDiscard2;
		uniform float4 _UVRangeDiscard2Range;
		uniform float _UVRangeDiscard3;
		uniform float4 _UVRangeDiscard3Range;
		uniform float _DiscardUVTile00;
		uniform float _DiscardUVTile01;
		uniform float _DiscardUVTile02;
		uniform float _DiscardUVTile03;
		uniform float _DiscardUVTile10;
		uniform float _DiscardUVTile11;
		uniform float _DiscardUVTile12;
		uniform float _DiscardUVTile13;
		uniform float _DiscardUVTile20;
		uniform float _DiscardUVTile21;
		uniform float _DiscardUVTile22;
		uniform float _DiscardUVTile23;
		uniform float _DiscardUVTile30;
		uniform float _DiscardUVTile31;
		uniform float _DiscardUVTile32;
		uniform float _DiscardUVTile33;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform half _EnableAudioLink;
		uniform sampler2D _AL_Mask;
		uniform float4 _AL_Mask_ST;
		uniform float _ALTimeScale;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _EmissionStrength;
		uniform half _EnableRimLighting;
		uniform sampler2D _RimNormalMap;
		uniform float _RimPower;
		uniform float _RimEnergy;
		uniform float _RimBaseColorStrength;
		uniform float _LightingType;
		uniform half _MaxFlatLightDistance;
		uniform float _FlatLightStrength;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _MultiMap;
		uniform float4 _MultiMap_ST;


		float IfAudioLinkv2Exists1_g14(  )
		{
			int w = 0; 
			int h; 
			int res = 0;
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS
			_AudioTexture.GetDimensions(w, h); 
			#endif
			if (w == 128) res = 1;
			return res;
		}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline float AudioLinkData3_g4( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g60( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g12( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g11( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 DiscardUV200 = v.texcoord1.xy;
			float2 break9_g250 = DiscardUV200;
			float4 break245 = _UVRangeDiscard1Range;
			float2 appendResult247 = (float2(break245.x , break245.y));
			float2 break11_g250 = appendResult247;
			float2 appendResult248 = (float2(break245.z , break245.w));
			float2 break13_g250 = appendResult248;
			float2 break9_g251 = DiscardUV200;
			float4 break252 = _UVRangeDiscard2Range;
			float2 appendResult253 = (float2(break252.x , break252.y));
			float2 break11_g251 = appendResult253;
			float2 appendResult254 = (float2(break252.z , break252.w));
			float2 break13_g251 = appendResult254;
			float2 break9_g252 = DiscardUV200;
			float4 break259 = _UVRangeDiscard3Range;
			float2 appendResult260 = (float2(break259.x , break259.y));
			float2 break11_g252 = appendResult260;
			float2 appendResult261 = (float2(break259.z , break259.w));
			float2 break13_g252 = appendResult261;
			float UVRangeDiscard267 = ( ( _UVRangeDiscard1 == 1.0 ? (( break9_g250.y >= break11_g250.y && break9_g250.y <= break13_g250.y ) ? (( break9_g250.x >= break11_g250.x && break9_g250.x <= break13_g250.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _UVRangeDiscard2 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g251.y >= break11_g251.y && break9_g251.y <= break13_g251.y ) ? (( break9_g251.x >= break11_g251.x && break9_g251.x <= break13_g251.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _UVRangeDiscard3 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g252.y >= break11_g252.y && break9_g252.y <= break13_g252.y ) ? (( break9_g252.x >= break11_g252.x && break9_g252.x <= break13_g252.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) );
			float2 break9_g256 = DiscardUV200;
			float2 temp_output_24_0_g256 = floor( float2( 0,0 ) );
			float2 break11_g256 = temp_output_24_0_g256;
			float2 break13_g256 = ( temp_output_24_0_g256 + float2( 1,1 ) );
			float2 break9_g257 = DiscardUV200;
			float2 temp_output_24_0_g257 = floor( float2( 0,1 ) );
			float2 break11_g257 = temp_output_24_0_g257;
			float2 break13_g257 = ( temp_output_24_0_g257 + float2( 1,1 ) );
			float2 break9_g258 = DiscardUV200;
			float2 temp_output_24_0_g258 = floor( float2( 0,2 ) );
			float2 break11_g258 = temp_output_24_0_g258;
			float2 break13_g258 = ( temp_output_24_0_g258 + float2( 1,1 ) );
			float2 break9_g259 = DiscardUV200;
			float2 temp_output_24_0_g259 = floor( float2( 0,3 ) );
			float2 break11_g259 = temp_output_24_0_g259;
			float2 break13_g259 = ( temp_output_24_0_g259 + float2( 1,1 ) );
			float2 break9_g253 = DiscardUV200;
			float2 temp_output_24_0_g253 = floor( float2( 1,0 ) );
			float2 break11_g253 = temp_output_24_0_g253;
			float2 break13_g253 = ( temp_output_24_0_g253 + float2( 1,1 ) );
			float2 break9_g260 = DiscardUV200;
			float2 temp_output_24_0_g260 = floor( float2( 1,1 ) );
			float2 break11_g260 = temp_output_24_0_g260;
			float2 break13_g260 = ( temp_output_24_0_g260 + float2( 1,1 ) );
			float2 break9_g261 = DiscardUV200;
			float2 temp_output_24_0_g261 = floor( float2( 1,2 ) );
			float2 break11_g261 = temp_output_24_0_g261;
			float2 break13_g261 = ( temp_output_24_0_g261 + float2( 1,1 ) );
			float2 break9_g262 = DiscardUV200;
			float2 temp_output_24_0_g262 = floor( float2( 1,3 ) );
			float2 break11_g262 = temp_output_24_0_g262;
			float2 break13_g262 = ( temp_output_24_0_g262 + float2( 1,1 ) );
			float2 break9_g254 = DiscardUV200;
			float2 temp_output_24_0_g254 = floor( float2( 2,0 ) );
			float2 break11_g254 = temp_output_24_0_g254;
			float2 break13_g254 = ( temp_output_24_0_g254 + float2( 1,1 ) );
			float2 break9_g265 = DiscardUV200;
			float2 temp_output_24_0_g265 = floor( float2( 2,1 ) );
			float2 break11_g265 = temp_output_24_0_g265;
			float2 break13_g265 = ( temp_output_24_0_g265 + float2( 1,1 ) );
			float2 break9_g264 = DiscardUV200;
			float2 temp_output_24_0_g264 = floor( float2( 2,2 ) );
			float2 break11_g264 = temp_output_24_0_g264;
			float2 break13_g264 = ( temp_output_24_0_g264 + float2( 1,1 ) );
			float2 break9_g263 = DiscardUV200;
			float2 temp_output_24_0_g263 = floor( float2( 2,3 ) );
			float2 break11_g263 = temp_output_24_0_g263;
			float2 break13_g263 = ( temp_output_24_0_g263 + float2( 1,1 ) );
			float2 break9_g255 = DiscardUV200;
			float2 temp_output_24_0_g255 = floor( float2( 3,0 ) );
			float2 break11_g255 = temp_output_24_0_g255;
			float2 break13_g255 = ( temp_output_24_0_g255 + float2( 1,1 ) );
			float2 break9_g266 = DiscardUV200;
			float2 temp_output_24_0_g266 = floor( float2( 3,1 ) );
			float2 break11_g266 = temp_output_24_0_g266;
			float2 break13_g266 = ( temp_output_24_0_g266 + float2( 1,1 ) );
			float2 break9_g267 = DiscardUV200;
			float2 temp_output_24_0_g267 = floor( float2( 3,2 ) );
			float2 break11_g267 = temp_output_24_0_g267;
			float2 break13_g267 = ( temp_output_24_0_g267 + float2( 1,1 ) );
			float2 break9_g268 = DiscardUV200;
			float2 temp_output_24_0_g268 = floor( float2( 3,3 ) );
			float2 break11_g268 = temp_output_24_0_g268;
			float2 break13_g268 = ( temp_output_24_0_g268 + float2( 1,1 ) );
			float UVTileDiscard192 = ( ( ( _DiscardUVTile00 == 1.0 ? (( break9_g256.y >= break11_g256.y && break9_g256.y <= break13_g256.y ) ? (( break9_g256.x >= break11_g256.x && break9_g256.x <= break13_g256.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile01 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g257.y >= break11_g257.y && break9_g257.y <= break13_g257.y ) ? (( break9_g257.x >= break11_g257.x && break9_g257.x <= break13_g257.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile02 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g258.y >= break11_g258.y && break9_g258.y <= break13_g258.y ) ? (( break9_g258.x >= break11_g258.x && break9_g258.x <= break13_g258.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile03 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g259.y >= break11_g259.y && break9_g259.y <= break13_g259.y ) ? (( break9_g259.x >= break11_g259.x && break9_g259.x <= break13_g259.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) ) + ( ( (( _DiscardUVTile10 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g253.y >= break11_g253.y && break9_g253.y <= break13_g253.y ) ? (( break9_g253.x >= break11_g253.x && break9_g253.x <= break13_g253.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile11 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g260.y >= break11_g260.y && break9_g260.y <= break13_g260.y ) ? (( break9_g260.x >= break11_g260.x && break9_g260.x <= break13_g260.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile12 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g261.y >= break11_g261.y && break9_g261.y <= break13_g261.y ) ? (( break9_g261.x >= break11_g261.x && break9_g261.x <= break13_g261.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile13 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g262.y >= break11_g262.y && break9_g262.y <= break13_g262.y ) ? (( break9_g262.x >= break11_g262.x && break9_g262.x <= break13_g262.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) ) + ( ( (( _DiscardUVTile20 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g254.y >= break11_g254.y && break9_g254.y <= break13_g254.y ) ? (( break9_g254.x >= break11_g254.x && break9_g254.x <= break13_g254.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile21 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g265.y >= break11_g265.y && break9_g265.y <= break13_g265.y ) ? (( break9_g265.x >= break11_g265.x && break9_g265.x <= break13_g265.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile22 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g264.y >= break11_g264.y && break9_g264.y <= break13_g264.y ) ? (( break9_g264.x >= break11_g264.x && break9_g264.x <= break13_g264.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile23 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g263.y >= break11_g263.y && break9_g263.y <= break13_g263.y ) ? (( break9_g263.x >= break11_g263.x && break9_g263.x <= break13_g263.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) ) + ( ( (( _DiscardUVTile30 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g255.y >= break11_g255.y && break9_g255.y <= break13_g255.y ) ? (( break9_g255.x >= break11_g255.x && break9_g255.x <= break13_g255.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile31 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g266.y >= break11_g266.y && break9_g266.y <= break13_g266.y ) ? (( break9_g266.x >= break11_g266.x && break9_g266.x <= break13_g266.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile32 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g267.y >= break11_g267.y && break9_g267.y <= break13_g267.y ) ? (( break9_g267.x >= break11_g267.x && break9_g267.x <= break13_g267.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) + ( (( _DiscardUVTile33 )?( 1.0 ):( 0.0 )) == 1.0 ? (( break9_g268.y >= break11_g268.y && break9_g268.y <= break13_g268.y ) ? (( break9_g268.x >= break11_g268.x && break9_g268.x <= break13_g268.x ) ? ( 0.0 / 0.0 ) :  0.0 ) :  0.0 ) : 0.0 ) ) );
			float UVDiscard730 = ( UVRangeDiscard267 + UVTileDiscard192 );
			float3 temp_cast_0 = (UVDiscard730).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 objToWorld389 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_cast_10 = (( ase_lightColor.a * ( 1.0 - _FlatLightStrength ) )).xxxx;
			float4 FlatLightColor414 = ( ase_lightColor - temp_cast_10 );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 normalMap35 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			UnityGI gi400 = gi;
			float3 diffNorm400 = normalMap35;
			gi400 = UnityGI_Base( data, 1, diffNorm400 );
			float3 indirectDiffuse400 = gi400.indirect.diffuse + diffNorm400 * 0.0001;
			float4 _FlatLightResult424 = ( ( ( _WorldSpaceLightPos0.w == 0.0 ? ( 1.0 - (0.0 + (distance( objToWorld389 , _WorldSpaceLightPos0.xyz ) - 0.0) * (1.0 - 0.0) / (_MaxFlatLightDistance - 0.0)) ) : 1.0 ) * FlatLightColor414 ) + unity_AmbientSky + float4( indirectDiffuse400 , 0.0 ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 mainTex26 = tex2D( _Albedo, uv_Albedo );
			float4 mainTexClamped354 = (float4( 0.01,0.01,0.01,0 ) + (mainTex26 - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0.01,0.01,0.01,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 )));
			float2 uv_MultiMap = i.uv_texcoord * _MultiMap_ST.xy + _MultiMap_ST.zw;
			float4 multiMap90 = tex2D( _MultiMap, uv_MultiMap );
			float4 break404 = multiMap90;
			float3 indirectNormal405 = normalize( WorldNormalVector( i , normalMap35 ) );
			Unity_GlossyEnvironmentData g405 = UnityGlossyEnvironmentSetup( break404.g, data.worldViewDir, indirectNormal405, float3(0,0,0));
			float3 indirectSpecular405 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal405, g405 );
			float4 Lighting_Flat411 = ( ( _FlatLightResult424 * mainTexClamped354 ) + ( break404.r * float4( indirectSpecular405 , 0.0 ) * _FlatLightResult424 ) );
			SurfaceOutputStandard s303 = (SurfaceOutputStandard ) 0;
			s303.Albedo = mainTex26.rgb;
			s303.Normal = normalize( WorldNormalVector( i , normalMap35 ) );
			float2 uv_AL_Mask = i.uv_texcoord * _AL_Mask_ST.xy + _AL_Mask_ST.zw;
			float4 ALMask39 = tex2D( _AL_Mask, uv_AL_Mask );
			float localIfAudioLinkv2Exists1_g14 = IfAudioLinkv2Exists1_g14();
			float4 color42 = IsGammaSpace() ? float4(1,0,0,1) : float4(1,0,0,1);
			float3 hsvTorgb4_g36 = RGBToHSV( color42.rgb );
			float mulTime48 = _Time.y * _ALTimeScale;
			float Time50 = frac( mulTime48 );
			float3 hsvTorgb8_g36 = HSVToRGB( float3(( hsvTorgb4_g36.x + Time50 ),( hsvTorgb4_g36.y + 0.0 ),( hsvTorgb4_g36.z + 0.0 )) );
			float3 temp_output_194_0 = saturate( hsvTorgb8_g36 );
			int Band3_g4 = 0;
			int Delay3_g4 = 0;
			float localAudioLinkData3_g4 = AudioLinkData3_g4( Band3_g4 , Delay3_g4 );
			float3 ALC_Bass61 = ( localIfAudioLinkv2Exists1_g14 == 1.0 ? ( temp_output_194_0 * localAudioLinkData3_g4 ) : temp_output_194_0 );
			float4 color44 = IsGammaSpace() ? float4(0,0.8196079,0,1) : float4(0,0.637597,0,1);
			float3 hsvTorgb4_g59 = RGBToHSV( color44.rgb );
			float3 hsvTorgb8_g59 = HSVToRGB( float3(( hsvTorgb4_g59.x + Time50 ),( hsvTorgb4_g59.y + 0.0 ),( hsvTorgb4_g59.z + 0.0 )) );
			int Band3_g60 = 2;
			int Delay3_g60 = 0;
			float localAudioLinkData3_g60 = AudioLinkData3_g60( Band3_g60 , Delay3_g60 );
			float3 ALC_HighMid67 = ( saturate( hsvTorgb8_g59 ) * localAudioLinkData3_g60 );
			float4 color43 = IsGammaSpace() ? float4(1,0.9294118,0,1) : float4(1,0.8468735,0,1);
			float3 hsvTorgb4_g38 = RGBToHSV( color43.rgb );
			float3 hsvTorgb8_g38 = HSVToRGB( float3(( hsvTorgb4_g38.x + Time50 ),( hsvTorgb4_g38.y + 0.0 ),( hsvTorgb4_g38.z + 0.0 )) );
			int Band3_g12 = 1;
			int Delay3_g12 = 0;
			float localAudioLinkData3_g12 = AudioLinkData3_g12( Band3_g12 , Delay3_g12 );
			float3 ALC_LowMid64 = ( saturate( hsvTorgb8_g38 ) * localAudioLinkData3_g12 );
			float4 color45 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
			float3 hsvTorgb4_g37 = RGBToHSV( color45.rgb );
			float3 hsvTorgb8_g37 = HSVToRGB( float3(( hsvTorgb4_g37.x + Time50 ),( hsvTorgb4_g37.y + 0.0 ),( hsvTorgb4_g37.z + 0.0 )) );
			int Band3_g11 = 3;
			int Delay3_g11 = 0;
			float localAudioLinkData3_g11 = AudioLinkData3_g11( Band3_g11 , Delay3_g11 );
			float3 ALC_Treble70 = ( saturate( hsvTorgb8_g37 ) * localAudioLinkData3_g11 );
			float4 AL_Final85 = ( _EnableAudioLink * ( ( ALMask39 * float4( ALC_Bass61 , 0.0 ) ) + ( ALMask39 * float4( ALC_HighMid67 , 0.0 ) ) + ( ALMask39 * float4( ALC_LowMid64 , 0.0 ) ) + ( ALMask39 * float4( ALC_Treble70 , 0.0 ) ) ) );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 Emission119 = ( tex2D( _Emission, uv_Emission ) * _EmissionStrength );
			float3 normalizeResult9 = normalize( i.viewDir );
			float dotResult10 = dot( UnpackNormal( tex2D( _RimNormalMap, i.uv_texcoord ) ) , normalizeResult9 );
			float Rim16 = ( pow( ( 1.0 - saturate( dotResult10 ) ) , ( 10.0 - _RimPower ) ) * _RimEnergy );
			float4 lerpResult114 = lerp( float4( 1,1,1,0 ) , mainTex26 , _RimBaseColorStrength);
			float4 Rim116 = ( _EnableRimLighting * ( Rim16 * lerpResult114 ) );
			float4 EmissionFinal29 = ( AL_Final85 + Emission119 + Rim116 );
			s303.Emission = EmissionFinal29.rgb;
			float4 break307 = multiMap90;
			s303.Metallic = break307.r;
			s303.Smoothness = break307.g;
			s303.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi303 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g303 = UnityGlossyEnvironmentSetup( s303.Smoothness, data.worldViewDir, s303.Normal, float3(0,0,0));
			gi303 = UnityGlobalIllumination( data, s303.Occlusion, s303.Normal, g303 );
			#endif

			float3 surfResult303 = LightingStandard ( s303, viewDir, gi303 ).rgb;
			surfResult303 += s303.Emission;

			#ifdef UNITY_PASS_FORWARDADD//303
			surfResult303 -= s303.Emission;
			#endif//303
			float3 Lighting_Standard309 = surfResult303;
			float4 temp_output_327_0 = ( _LightingType == 1.0 ? Lighting_Flat411 : float4( Lighting_Standard309 , 0.0 ) );
			float4 LightingFinal330 = temp_output_327_0;
			c.rgb = LightingFinal330.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 mainTex26 = tex2D( _Albedo, uv_Albedo );
			o.Albedo = mainTex26.rgb;
			float2 uv_AL_Mask = i.uv_texcoord * _AL_Mask_ST.xy + _AL_Mask_ST.zw;
			float4 ALMask39 = tex2D( _AL_Mask, uv_AL_Mask );
			float localIfAudioLinkv2Exists1_g14 = IfAudioLinkv2Exists1_g14();
			float4 color42 = IsGammaSpace() ? float4(1,0,0,1) : float4(1,0,0,1);
			float3 hsvTorgb4_g36 = RGBToHSV( color42.rgb );
			float mulTime48 = _Time.y * _ALTimeScale;
			float Time50 = frac( mulTime48 );
			float3 hsvTorgb8_g36 = HSVToRGB( float3(( hsvTorgb4_g36.x + Time50 ),( hsvTorgb4_g36.y + 0.0 ),( hsvTorgb4_g36.z + 0.0 )) );
			float3 temp_output_194_0 = saturate( hsvTorgb8_g36 );
			int Band3_g4 = 0;
			int Delay3_g4 = 0;
			float localAudioLinkData3_g4 = AudioLinkData3_g4( Band3_g4 , Delay3_g4 );
			float3 ALC_Bass61 = ( localIfAudioLinkv2Exists1_g14 == 1.0 ? ( temp_output_194_0 * localAudioLinkData3_g4 ) : temp_output_194_0 );
			float4 color44 = IsGammaSpace() ? float4(0,0.8196079,0,1) : float4(0,0.637597,0,1);
			float3 hsvTorgb4_g59 = RGBToHSV( color44.rgb );
			float3 hsvTorgb8_g59 = HSVToRGB( float3(( hsvTorgb4_g59.x + Time50 ),( hsvTorgb4_g59.y + 0.0 ),( hsvTorgb4_g59.z + 0.0 )) );
			int Band3_g60 = 2;
			int Delay3_g60 = 0;
			float localAudioLinkData3_g60 = AudioLinkData3_g60( Band3_g60 , Delay3_g60 );
			float3 ALC_HighMid67 = ( saturate( hsvTorgb8_g59 ) * localAudioLinkData3_g60 );
			float4 color43 = IsGammaSpace() ? float4(1,0.9294118,0,1) : float4(1,0.8468735,0,1);
			float3 hsvTorgb4_g38 = RGBToHSV( color43.rgb );
			float3 hsvTorgb8_g38 = HSVToRGB( float3(( hsvTorgb4_g38.x + Time50 ),( hsvTorgb4_g38.y + 0.0 ),( hsvTorgb4_g38.z + 0.0 )) );
			int Band3_g12 = 1;
			int Delay3_g12 = 0;
			float localAudioLinkData3_g12 = AudioLinkData3_g12( Band3_g12 , Delay3_g12 );
			float3 ALC_LowMid64 = ( saturate( hsvTorgb8_g38 ) * localAudioLinkData3_g12 );
			float4 color45 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
			float3 hsvTorgb4_g37 = RGBToHSV( color45.rgb );
			float3 hsvTorgb8_g37 = HSVToRGB( float3(( hsvTorgb4_g37.x + Time50 ),( hsvTorgb4_g37.y + 0.0 ),( hsvTorgb4_g37.z + 0.0 )) );
			int Band3_g11 = 3;
			int Delay3_g11 = 0;
			float localAudioLinkData3_g11 = AudioLinkData3_g11( Band3_g11 , Delay3_g11 );
			float3 ALC_Treble70 = ( saturate( hsvTorgb8_g37 ) * localAudioLinkData3_g11 );
			float4 AL_Final85 = ( _EnableAudioLink * ( ( ALMask39 * float4( ALC_Bass61 , 0.0 ) ) + ( ALMask39 * float4( ALC_HighMid67 , 0.0 ) ) + ( ALMask39 * float4( ALC_LowMid64 , 0.0 ) ) + ( ALMask39 * float4( ALC_Treble70 , 0.0 ) ) ) );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 Emission119 = ( tex2D( _Emission, uv_Emission ) * _EmissionStrength );
			float3 normalizeResult9 = normalize( i.viewDir );
			float dotResult10 = dot( UnpackNormal( tex2D( _RimNormalMap, i.uv_texcoord ) ) , normalizeResult9 );
			float Rim16 = ( pow( ( 1.0 - saturate( dotResult10 ) ) , ( 10.0 - _RimPower ) ) * _RimEnergy );
			float4 lerpResult114 = lerp( float4( 1,1,1,0 ) , mainTex26 , _RimBaseColorStrength);
			float4 Rim116 = ( _EnableRimLighting * ( Rim16 * lerpResult114 ) );
			float4 EmissionFinal29 = ( AL_Final85 + Emission119 + Rim116 );
			o.Emission = EmissionFinal29.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;732;4769.539,1474.229;Inherit;False;626.3779;265.5669;Comment;4;728;729;731;730;Combine UV Discards;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;220;2051.233,-3370.865;Inherit;False;962.8354;715.8684;Comment;8;0;33;36;32;95;92;193;332;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;201;-55.94421,-697.3302;Inherit;False;503.0845;214.413;Comment;2;200;199;Discard UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;107;-23.66935,-4536.875;Inherit;False;1258.848;948.373;Comment;16;85;84;83;82;81;80;79;78;76;77;75;74;73;71;415;416;AudioLink Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;106;-112.9787,-5381.73;Inherit;False;1183.572;355.2229;Comment;5;57;69;68;70;45;AudioLink Treble;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;105;-86.35403,-5893.254;Inherit;False;1188.215;403.241;Comment;6;67;65;66;56;44;197;AudioLink HighMid;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-1337.905,-5407.259;Inherit;False;1137.62;367.6456;Comment;5;64;63;62;55;43;AudioLink LowMid;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;103;-1337.02,-5897.206;Inherit;False;1176.516;390.1733;Comment;7;42;61;41;124;58;51;417;AudioLink Bass;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;72;-1818.04,-4819.045;Inherit;False;712.9634;194.3457;Comment;4;243;48;49;50;Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-7417.041,-1620.861;Inherit;False;859.9141;343.3768;Comment;3;737;34;35;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-636.0011,-1983.635;Inherit;False;737.2792;402.4306;Comment;5;29;86;28;30;122;Emission Combination;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-7513.137,-3602.244;Inherit;False;914.3999;338.0557;Comment;3;736;25;26;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;-3015.296,-577.5867;Inherit;False;2619.73;1242.488;Comment;20;333;114;4;116;113;112;115;87;8;9;10;88;16;12;7;15;14;13;11;334;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1849.337,-3502.624;Inherit;False;604.8932;280;Comment;2;40;39;AL Emission Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-1329.076,-4762.699;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;89;-813.4411,-2813.33;Inherit;False;604.8932;280;R = Metalic, G = Smoothness;2;91;90;MultiMap;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-424.5481,-2761.528;Inherit;False;multiMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;134.7981,-5172.021;Inherit;False;50;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;637.4441,-5280.506;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;846.5929,-5305.182;Inherit;False;ALC_Treble;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;45;-62.97868,-5253.461;Inherit;False;Constant;_AL_Treble;AL_Treble;6;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;71;26.79314,-4486.875;Inherit;False;39;ALMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;26.33066,-4372.526;Inherit;False;61;ALC_Bass;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;211.3306,-4443.526;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;42.57924,-4245.578;Inherit;False;39;ALMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;227.1167,-4202.23;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;42.11675,-4131.23;Inherit;False;67;ALC_HighMid;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;67.26691,-4009.6;Inherit;False;39;ALMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;251.8044,-3966.252;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;67.80442,-3895.252;Inherit;False;64;ALC_LowMid;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;76.93356,-3805.6;Inherit;False;39;ALMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;261.471,-3762.253;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;77.47105,-3691.253;Inherit;False;70;ALC_Treble;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;534.6252,-4158.036;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-1471.095,-3451.473;Inherit;False;ALMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;117;-1853.104,-2983.999;Inherit;False;791.7242;362.8555;Comment;4;120;119;118;121;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-1276.658,-2924.725;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-1771.553,-2723.966;Inherit;False;Property;_EmissionStrength;Emission Strength;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-1444.109,-2847.282;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;11;-2179.434,-304.2606;Inherit;False;1;0;FLOAT;1.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;13;-2010.431,-261.9613;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-2234.424,-176.6531;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-1817.633,-238.5608;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;7;-2780.132,-251.9605;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;12;-2650.262,-92.36382;Float;False;Property;_RimPower;Rim Power;13;0;Create;True;0;0;0;False;0;False;2.07;3.39;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1406.557,-282.4929;Float;True;Rim;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1609.907,-202.9594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;10;-2398.068,-404.9769;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;9;-2568.881,-243.393;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;8;-2720.214,-488.9528;Inherit;True;Property;_RimNormalMap;Rim Normal Map;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-1893.711,-79.22301;Inherit;False;Property;_RimEnergy;Rim Energy;14;0;Create;True;0;0;0;False;0;False;0.345;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-1179.027,-112.8811;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-1645.213,99.48186;Inherit;False;26;mainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1765.622,197.6751;Inherit;False;Property;_RimBaseColorStrength;Rim Base Color Strength;15;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2957.279,-460.7114;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;114;-1441.166,47.19511;Inherit;True;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;40;-1793.337,-3445.624;Inherit;True;Property;_AL_Mask;AL_Mask;7;0;Create;True;0;0;0;False;0;False;-1;83f90c05f51ea5c469ceb2c4218b09a7;83f90c05f51ea5c469ceb2c4218b09a7;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1247.875,-5610.916;Inherit;False;50;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-735.7633,-5741.359;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;41;-1052.972,-5786.569;Inherit;False;4BandAmplitude;-1;;4;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-367.5052,-5782.771;Inherit;False;ALC_Bass;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;42;-1312.543,-5798.206;Inherit;False;Constant;_AL_Bass;AL_Bass;6;0;Create;True;0;0;0;False;0;False;1,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;68;343.0645,-5166.744;Inherit;False;4BandAmplitude;-1;;11;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;3;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;-1294.715,-5338.324;Inherit;False;Constant;_AL_LowMid;AL_LowMid;6;0;Create;True;0;0;0;False;0;False;1,0.9294118,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1102.38,-5249.526;Inherit;False;50;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;62;-919.6196,-5182.47;Inherit;False;4BandAmplitude;-1;;12;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;1;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-644.6395,-5299.407;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-415.1543,-5306.091;Inherit;False;ALC_LowMid;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;44;-54.51395,-5792.144;Inherit;False;Constant;_AL_HighMid;AL_HighMid;6;0;Create;True;0;0;0;False;0;False;0,0.8196079,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;56;141.1703,-5704.85;Inherit;False;50;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;665.2375,-5831.361;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;879.6917,-5819.153;Inherit;False;ALC_HighMid;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;124;-747.4884,-5834.831;Inherit;False;IsAudioLink;-1;;14;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;138;936.447,-995.565;Inherit;False;3952.421;2004.957;Comment;58;631;630;204;163;203;164;629;198;270;224;222;223;191;192;225;216;215;214;213;212;211;210;209;205;206;208;207;202;186;185;184;183;180;173;172;171;170;167;162;161;160;159;154;149;141;632;633;634;635;636;637;638;639;640;641;642;643;644;UV Tile Discard;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;141;990.0652,-360.4861;Inherit;False;Property;_DiscardUVTile01;Discard UV Tile 0,1;17;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;1574.041,-29.37679;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;2361.4,4.925166;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;159;1754.841,-567.1594;Inherit;False;Property;_DiscardUVTile10;Discard UV Tile 1,0;20;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;167;3157.587,-121.3273;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;172;2538.16,-548.0706;Inherit;False;Property;_DiscardUVTile20;Discard UV Tile 2,0;24;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;3952.679,-123.3625;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;183;3333.252,-550.1058;Inherit;False;Property;_DiscardUVTile30;Discard UV Tile 3,0;28;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;194;-1058.552,-5678.013;Inherit;False;HueShift;-1;;36;09c7357f8ce789c46a405a6704ca8341;0;4;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;195;343.6559,-5323.875;Inherit;False;HueShift;-1;;37;09c7357f8ce789c46a405a6704ca8341;0;4;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;196;-907.4175,-5335.405;Inherit;False;HueShift;-1;;38;09c7357f8ce789c46a405a6704ca8341;0;4;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;1004.224,-253.9884;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;205;1765.512,-459.5844;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;2561.651,-432.2817;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;3334.27,-413.5894;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;217;3228.887,-4815.999;Inherit;False;420.8079;185;Comment;2;219;218;Declare NaN;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;219;3425.695,-4764.384;Inherit;False;NaN;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2759.068,-3220.523;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;VoyVivika/DivorceShaders/Divorce Main;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;1;Include;Assets/AudioLink/Shaders/AudioLink.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;2286.262,-3320.865;Inherit;False;26;mainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;2297.222,-3237.719;Inherit;False;35;normalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;2301.754,-3145.94;Inherit;False;29;EmissionFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;95;2282.518,-3022.374;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;225;1676.254,-711.4808;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;192;4647.759,-868.7963;Inherit;False;UVTileDiscard;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;4344.228,-842.1623;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;223;3297.711,-620.9256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;222;4090.643,-609.0677;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;224;2511.907,-670.8979;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;223.1403,-647.3302;Inherit;False;DiscardUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;199;-5.944214,-641.9172;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;92;2101.233,-3026.873;Inherit;False;90;multiMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;118;-1797.104,-2926.999;Inherit;True;Property;_Emission;Emission;9;0;Create;True;0;0;0;False;0;False;-1;83f90c05f51ea5c469ceb2c4218b09a7;83f90c05f51ea5c469ceb2c4218b09a7;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;49;-1440.809,-4759.045;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;48;-1600.04,-4757.258;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;243;-1786.835,-4764.416;Inherit;False;Property;_ALTimeScale;AL Time Scale;8;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;244;5665.53,-1084.681;Inherit;False;1473.337;1437.826;Comment;20;267;266;265;264;262;261;260;259;258;257;255;254;253;252;249;248;247;246;245;466;UV Range Discard;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;245;5975.529,-792.7888;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;247;6108.968,-816.7595;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;248;6108.968,-720.7596;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;249;6067.578,-892.1313;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;252;6005.116,-342.5569;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;253;6138.553,-366.5276;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;254;6138.553,-270.5276;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;255;6097.163,-441.8993;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;258;5745.116,-345.5569;Inherit;False;Property;_UVRangeDiscard2Range;UV Range Discard 2 Range;35;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;259;6068.03,144.1448;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;260;6201.468,120.1747;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;261;6201.468,216.1747;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;262;6160.077,44.80279;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;264;5808.031,141.1448;Inherit;False;Property;_UVRangeDiscard3Range;UV Range Discard 3 Range;37;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;266;6692.469,-484.9842;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;267;6904.867,-437.2843;Inherit;False;UVRangeDiscard;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;257;6039.498,-584.4487;Inherit;False;Property;_UVRangeDiscard2;UV Range Discard 2;34;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;265;6103.412,-97.74685;Inherit;False;Property;_UVRangeDiscard3;UV Range Discard 3;36;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;302;774.3953,-6622.291;Inherit;False;1151.4;546.5259;Comment;7;309;308;307;306;305;304;303;Standard Lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.CustomStandardSurface;303;1334.396,-6510.291;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;1030.396,-6574.291;Inherit;False;26;mainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;1030.396,-6414.291;Inherit;False;29;EmissionFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;1046.396,-6494.291;Inherit;False;35;normalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;307;1030.396,-6334.291;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;308;822.3953,-6414.291;Inherit;False;90;multiMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;309;1622.396,-6510.291;Inherit;False;Lighting_Standard;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;326;1801.181,-5722.331;Inherit;False;1369.996;727.8779;Comment;8;328;327;331;330;329;470;471;472;Pick Lighting Type;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;332;2519.215,-2997.911;Inherit;False;330;LightingFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-655.0269,-125.8811;Float;True;Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;334;-851.8262,-135.8871;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;333;-1167.852,-280.5502;Half;False;Property;_EnableRimLighting;Enable Rim Lighting;11;1;[ToggleUI];Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;337;3600.322,-7307.744;Inherit;False;1742.432;894.1182;Comment;15;339;369;370;364;366;365;344;362;363;361;360;346;345;340;338;Test Lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;1856.181,-5467.046;Inherit;False;309;Lighting_Standard;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;330;2850.206,-5585.539;Inherit;False;LightingFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;351;2447.666,-6211.748;Inherit;False;753.479;304;Comment;3;354;353;352;MainTexClamped;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;353;2497.666,-6118.865;Inherit;False;26;mainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;3627.781,-7233.255;Inherit;False;35;normalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;4146.47,-7127.524;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;346;3803.2,-7024.844;Inherit;False;354;mainTexClamped;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;360;3770.741,-6674.972;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;361;3769.331,-6923.813;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightAttenuation;363;4024.339,-6635.645;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;362;4026.184,-6822.177;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;4253.118,-6779.934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;4446.474,-7074.04;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;366;4392.474,-6866.04;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;364;4477.963,-6762.737;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;370;4663.398,-6968.224;Inherit;False;29;EmissionFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;369;4919.632,-7189.752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;339;5112.2,-7202.131;Inherit;False;TestLighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;382;1762.503,-9017.584;Inherit;False;2298.22;1596.4;Comment;34;439;438;437;411;400;401;387;391;424;393;390;402;410;425;397;406;428;427;426;409;405;404;403;394;398;399;396;395;392;389;386;385;384;383;Flat Lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.DistanceOpNode;383;2247.686,-8969.584;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;384;2503.686,-8969.584;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;385;2695.686,-8969.584;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;386;2727.686,-8825.584;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;389;1991.686,-8969.584;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;392;2271.798,-8781.396;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;396;1981.882,-8448.025;Inherit;False;unity_AmbientSky;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;354;2963.145,-6144.729;Inherit;False;mainTexClamped;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;329;1887.181,-5556.046;Inherit;False;411;Lighting_Flat;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;412;2274.243,-9750.891;Inherit;False;1054.539;478.8659;Comment;6;435;445;413;434;443;414;Flat Light Color (Clamp Toggle);1,1,1,1;0;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;345;3829.342,-7248.038;Inherit;False;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;992.705,-4166.425;Inherit;False;AL_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;416;787.8911,-4176.061;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;417;-539.5048,-5751.281;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;197;368.8238,-5818.455;Inherit;False;HueShift;-1;;59;09c7357f8ce789c46a405a6704ca8341;0;4;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;65;362.9142,-5666.229;Inherit;False;4BandAmplitude;-1;;60;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;2;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;415;478.4037,-4285.905;Half;False;Property;_EnableAudioLink;Enable AudioLink;6;1;[ToggleUI];Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;352;2671.076,-6161.748;Inherit;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0.01,0.01,0.01,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;399;2410.253,-8556.256;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;398;2247.384,-8573.471;Inherit;False;2;2;0;FLOAT;1;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;394;2231.343,-8616.508;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;403;2064.071,-8007.476;Inherit;False;90;multiMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;404;2236.83,-8009.762;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.IndirectSpecularLight;405;2426.593,-8008.148;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;409;2199.771,-8116.389;Inherit;False;35;normalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;426;2465.032,-7880.566;Inherit;False;424;_FlatLightResult;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;2414.428,-8147.837;Inherit;False;354;mainTexClamped;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;425;2423.175,-8223.939;Inherit;False;424;_FlatLightResult;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;410;2643.553,-8188.009;Inherit;False;2;2;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;402;2830.672,-8100.844;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;390;1982.686,-8809.584;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.Compare;393;2304.22,-8767.143;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;91;-795.4411,-2748.33;Inherit;True;Property;_MultiMap;MultiMap;5;0;Create;True;0;0;0;False;0;False;-1;01e8d4996fddd0a448744957657de587;01e8d4996fddd0a448744957657de587;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;387;2246.908,-8864.807;Half;False;Property;_MaxFlatLightDistance;Max Flat Light Distance;1;1;[Header];Create;True;1;Flat Light Settings;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;401;1989.305,-8362.608;Inherit;False;35;normalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;400;2160.805,-8340.71;Inherit;False;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;438;2298.203,-7792.808;Inherit;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.FogParamsNode;437;2301.924,-7712.6;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;439;2589.203,-7741.808;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;2673.307,-8030.653;Inherit;False;3;3;0;FLOAT;1;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;427;2403.356,-8047.526;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;428;2610.356,-8040.526;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;391;1823.305,-8589.877;Inherit;False;414;FlatLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;414;3109.108,-9650.771;Inherit;False;FlatLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;443;2971.555,-9644.028;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;395;2434.743,-8627.409;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;434;2800,-9578.407;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;411;2991.362,-8102.75;Inherit;False;Lighting_Flat;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;424;2604.884,-8556.707;Inherit;False;_FlatLightResult;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;445;2610.641,-9507.793;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;435;2318.901,-9504.486;Inherit;False;Property;_FlatLightStrength;Flat Light Strength;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;270;977.1765,-689.3776;Inherit;False;Property;_DiscardUVTile00;Discard UV Tile 0,0;16;2;[Header];[ToggleUI];Create;True;1;UV Tile Discard;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;413;2615.557,-9651.729;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.Compare;327;2192.754,-5646.564;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;469;2390.167,-5621.258;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;2;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;2172.167,-5466.258;Inherit;False;339;TestLighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;471;2177.167,-5680.258;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;472;2337.167,-5668.258;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;331;1987.591,-5672.331;Inherit;False;Property;_LightingType;Lighting Type;0;1;[Enum];Create;True;0;2;Standard;0;Flat;1;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;218;3278.887,-4765.999;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-594.7267,-1906.872;Inherit;False;85;AL_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-339.5763,-1838.825;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-114.9731,-1846.543;Inherit;False;EmissionFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-593.0291,-1816.919;Inherit;False;119;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-594.8048,-1719.686;Inherit;False;116;Rim;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-6840.288,-3509.053;Inherit;False;mainTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-6772.686,-1513.261;Inherit;False;normalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;1013.25,-573.5831;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;629;1010.338,-495.1187;Inherit;False;Constant;_Vector0;Vector 0;38;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ToggleSwitchNode;164;979.8055,59.51138;Inherit;False;Property;_DiscardUVTile02;Discard UV Tile 0,2;18;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;993.9236,182.8116;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;163;998.1068,427.7282;Inherit;False;Property;_DiscardUVTile03;Discard UV Tile 0,3;19;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;1027.324,558.4116;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;630;1009.611,-172.6724;Inherit;False;Constant;_Vector1;Vector 0;38;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;631;1024.328,282.1426;Inherit;False;Constant;_Vector2;Vector 0;38;0;Create;True;0;0;0;False;0;False;0,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;632;1050.693,653.3887;Inherit;False;Constant;_Vector3;Vector 0;38;0;Create;True;0;0;0;False;0;False;0,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ToggleSwitchNode;160;1750.116,-217.3762;Inherit;False;Property;_DiscardUVTile11;Discard UV Tile 1,1;21;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;1764.88,-84.74181;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;161;1733.172,166.8767;Inherit;False;Property;_DiscardUVTile12;Discard UV Tile 1,2;22;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;1753.145,302.4512;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;162;1748.012,606.9913;Inherit;False;Property;_DiscardUVTile13;Discard UV Tile 1,3;23;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;1770.984,725.981;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;633;1795.444,-366.9556;Inherit;False;Constant;_Vector4;Vector 0;38;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;634;1792.444,12.04443;Inherit;False;Constant;_Vector5;Vector 0;38;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;635;1800.225,437.1756;Inherit;False;Constant;_Vector6;Vector 0;38;0;Create;True;0;0;0;False;0;False;1,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;636;1817.125,849.2758;Inherit;False;Constant;_Vector7;Vector 0;38;0;Create;True;0;0;0;False;0;False;1,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ToggleSwitchNode;173;2550.805,581.2797;Inherit;False;Property;_DiscardUVTile23;Discard UV Tile 2,3;27;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;2571.191,701.3813;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;170;2543.904,185.5518;Inherit;False;Property;_DiscardUVTile22;Discard UV Tile 2,2;26;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;2573.269,310.2693;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;171;2541.389,-188.8031;Inherit;False;Property;_DiscardUVTile21;Discard UV Tile 2,1;25;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;210;2550.894,-64.50293;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;637;2577.726,-325.6877;Inherit;False;Constant;_Vector8;Vector 0;38;0;Create;True;0;0;0;False;0;False;2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;638;2597.095,45.7724;Inherit;False;Constant;_Vector9;Vector 0;38;0;Create;True;0;0;0;False;0;False;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;639;2604.095,424.7724;Inherit;False;Constant;_Vector10;Vector 0;38;0;Create;True;0;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;640;2601.095,827.7725;Inherit;False;Constant;_Vector11;Vector 0;38;0;Create;True;0;0;0;False;0;False;2,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ToggleSwitchNode;184;3325.936,-158.5218;Inherit;False;Property;_DiscardUVTile31;Discard UV Tile 3,1;29;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;3357.621,-26.99403;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;185;3331.027,199.3884;Inherit;False;Property;_DiscardUVTile32;Discard UV Tile 3,2;30;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;3358.688,319.9486;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;186;3319.659,602.5936;Inherit;False;Property;_DiscardUVTile33;Discard UV Tile 3,3;31;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;3325.88,714.3463;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;641;3378.129,-305.0728;Inherit;False;Constant;_Vector12;Vector 0;38;0;Create;True;0;0;0;False;0;False;3,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;642;3405.449,60.90466;Inherit;False;Constant;_Vector13;Vector 0;38;0;Create;True;0;0;0;False;0;False;3,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;643;3400.449,434.9046;Inherit;False;Constant;_Vector14;Vector 0;38;0;Create;True;0;0;0;False;0;False;3,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;644;3382.449,835.9047;Inherit;False;Constant;_Vector15;Vector 0;38;0;Create;True;0;0;0;False;0;False;3,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;709;6292.487,-915.9605;Inherit;False;UV Range Discard;-1;;250;59eaa82e4bf18fa44b47aa07cd25b8a2;0;4;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;12;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;710;6322.072,-465.7282;Inherit;False;UV Range Discard;-1;;251;59eaa82e4bf18fa44b47aa07cd25b8a2;0;4;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;12;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;711;6384.986,20.97381;Inherit;False;UV Range Discard;-1;;252;59eaa82e4bf18fa44b47aa07cd25b8a2;0;4;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;12;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;712;2012.833,-517.0515;Inherit;False;UV Tile Discard;-1;;253;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;713;2794.187,-480.5318;Inherit;False;UV Tile Discard;-1;;254;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;714;3589.279,-482.5672;Inherit;False;UV Tile Discard;-1;;255;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;715;1250.798,-536.7605;Inherit;False;UV Tile Discard;-1;;256;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;716;1249.957,-295.6591;Inherit;False;UV Tile Discard;-1;;257;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;717;1243.657,120.6382;Inherit;False;UV Tile Discard;-1;;258;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;718;1260.057,486.2371;Inherit;False;UV Tile Discard;-1;;259;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;719;2008.009,-161.0521;Inherit;False;UV Tile Discard;-1;;260;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;720;1999.767,231.7464;Inherit;False;UV Tile Discard;-1;;261;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;721;2013.448,667.2444;Inherit;False;UV Tile Discard;-1;;262;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;722;2812.757,639.7888;Inherit;False;UV Tile Discard;-1;;263;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;723;2804.857,244.778;Inherit;False;UV Tile Discard;-1;;264;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;724;2806.619,-133.7792;Inherit;False;UV Tile Discard;-1;;265;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;725;3584.195,-103.4978;Inherit;False;UV Tile Discard;-1;;266;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;726;3591.98,257.6147;Inherit;False;UV Tile Discard;-1;;267;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;727;3581.611,661.1027;Inherit;False;UV Tile Discard;-1;;268;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;728;4819.539,1524.229;Inherit;False;267;UVRangeDiscard;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;729;4821.917,1623.795;Inherit;False;192;UVTileDiscard;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;731;5045.917,1573.795;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;730;5171.917,1563.795;Inherit;False;UVDiscard;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;2351.81,-2859.997;Inherit;False;730;UVDiscard;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;466;5994.847,-999.995;Inherit;False;Property;_UVRangeDiscard1;UV Range Discard 1;32;2;[Header];[ToggleUI];Create;True;3;UV Range Discard;X and Y are Start UVs;Z and W are End UVs;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;246;5715.53,-795.7888;Inherit;False;Property;_UVRangeDiscard1Range;UV Range Discard 1 Range;33;0;Create;True;3;UV Range Discard;X and Y are Start UVs;Z and W are End UVs;0;0;False;0;False;0,0,1,1;0,0,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-7141.458,-3513.226;Inherit;True;Property;_AlbedoSample;Albedo Sample;3;0;Create;True;0;0;0;False;0;False;-1;0db631ddb1a2c1443b81c6ac5ce43d11;0db631ddb1a2c1443b81c6ac5ce43d11;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-7090.542,-1509.947;Inherit;True;Property;_NMSample;NM Sample;4;0;Create;True;0;0;0;False;0;False;-1;13ce54de7ec2bdd45a3ceb8a5e5e4cad;1f3982b36e89bca46b80f47660759b39;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;737;-7386.651,-1509.456;Inherit;True;Property;_NormalMap;Normal Map;4;0;Create;True;0;0;0;False;0;False;0f9978e19d98bb04b8f2ce5197640506;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;736;-7467.361,-3512.755;Inherit;True;Property;_Albedo;Albedo;3;0;Create;True;0;0;0;False;0;False;0db631ddb1a2c1443b81c6ac5ce43d11;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
WireConnection;50;0;49;0
WireConnection;90;0;91;0
WireConnection;69;0;195;0
WireConnection;69;1;68;0
WireConnection;70;0;69;0
WireConnection;74;0;71;0
WireConnection;74;1;73;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;79;0;78;0
WireConnection;79;1;80;0
WireConnection;82;0;81;0
WireConnection;82;1;83;0
WireConnection;84;0;74;0
WireConnection;84;1;77;0
WireConnection;84;2;79;0
WireConnection;84;3;82;0
WireConnection;39;0;40;0
WireConnection;119;0;121;0
WireConnection;121;0;118;0
WireConnection;121;1;120;0
WireConnection;11;0;10;0
WireConnection;13;0;11;0
WireConnection;14;1;12;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;16;0;88;0
WireConnection;88;0;15;0
WireConnection;88;1;87;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;9;0;7;0
WireConnection;8;1;4;0
WireConnection;115;0;16;0
WireConnection;115;1;114;0
WireConnection;114;1;112;0
WireConnection;114;2;113;0
WireConnection;58;0;194;0
WireConnection;58;1;41;0
WireConnection;61;0;417;0
WireConnection;63;0;196;0
WireConnection;63;1;62;0
WireConnection;64;0;63;0
WireConnection;66;0;197;0
WireConnection;66;1;65;0
WireConnection;67;0;66;0
WireConnection;149;0;715;0
WireConnection;149;1;716;0
WireConnection;149;2;717;0
WireConnection;149;3;718;0
WireConnection;154;0;712;0
WireConnection;154;1;719;0
WireConnection;154;2;720;0
WireConnection;154;3;721;0
WireConnection;167;0;713;0
WireConnection;167;1;724;0
WireConnection;167;2;723;0
WireConnection;167;3;722;0
WireConnection;180;0;714;0
WireConnection;180;1;725;0
WireConnection;180;2;726;0
WireConnection;180;3;727;0
WireConnection;194;14;42;0
WireConnection;194;15;51;0
WireConnection;195;14;45;0
WireConnection;195;15;57;0
WireConnection;196;14;43;0
WireConnection;196;15;55;0
WireConnection;219;0;218;0
WireConnection;0;0;33;0
WireConnection;0;2;32;0
WireConnection;0;13;332;0
WireConnection;0;11;193;0
WireConnection;95;0;92;0
WireConnection;225;0;149;0
WireConnection;192;0;191;0
WireConnection;191;0;225;0
WireConnection;191;1;224;0
WireConnection;191;2;223;0
WireConnection;191;3;222;0
WireConnection;223;0;167;0
WireConnection;222;0;180;0
WireConnection;224;0;154;0
WireConnection;200;0;199;0
WireConnection;49;0;48;0
WireConnection;48;0;243;0
WireConnection;245;0;246;0
WireConnection;247;0;245;0
WireConnection;247;1;245;1
WireConnection;248;0;245;2
WireConnection;248;1;245;3
WireConnection;252;0;258;0
WireConnection;253;0;252;0
WireConnection;253;1;252;1
WireConnection;254;0;252;2
WireConnection;254;1;252;3
WireConnection;259;0;264;0
WireConnection;260;0;259;0
WireConnection;260;1;259;1
WireConnection;261;0;259;2
WireConnection;261;1;259;3
WireConnection;266;0;709;0
WireConnection;266;1;710;0
WireConnection;266;2;711;0
WireConnection;267;0;266;0
WireConnection;303;0;304;0
WireConnection;303;1;306;0
WireConnection;303;2;305;0
WireConnection;303;3;307;0
WireConnection;303;4;307;1
WireConnection;307;0;308;0
WireConnection;309;0;303;0
WireConnection;116;0;334;0
WireConnection;334;0;333;0
WireConnection;334;1;115;0
WireConnection;330;0;327;0
WireConnection;340;0;345;0
WireConnection;340;1;346;0
WireConnection;362;0;361;0
WireConnection;362;1;360;0
WireConnection;344;0;362;0
WireConnection;344;1;363;0
WireConnection;365;0;340;0
WireConnection;365;1;366;0
WireConnection;366;0;364;0
WireConnection;364;0;344;0
WireConnection;369;0;365;0
WireConnection;369;1;370;0
WireConnection;339;0;369;0
WireConnection;383;0;389;0
WireConnection;383;1;390;1
WireConnection;384;0;383;0
WireConnection;384;2;387;0
WireConnection;385;0;384;0
WireConnection;386;0;385;0
WireConnection;392;0;386;0
WireConnection;354;0;352;0
WireConnection;345;0;338;0
WireConnection;85;0;416;0
WireConnection;416;0;415;0
WireConnection;416;1;84;0
WireConnection;417;0;124;0
WireConnection;417;2;58;0
WireConnection;417;3;194;0
WireConnection;197;14;44;0
WireConnection;197;15;56;0
WireConnection;352;0;353;0
WireConnection;399;0;398;0
WireConnection;399;1;396;0
WireConnection;399;2;400;0
WireConnection;398;0;394;0
WireConnection;398;1;391;0
WireConnection;394;0;395;0
WireConnection;404;0;403;0
WireConnection;405;0;409;0
WireConnection;405;1;404;1
WireConnection;410;0;425;0
WireConnection;410;1;397;0
WireConnection;402;0;410;0
WireConnection;402;1;406;0
WireConnection;393;0;390;2
WireConnection;393;2;392;0
WireConnection;400;0;401;0
WireConnection;439;0;437;4
WireConnection;439;1;438;0
WireConnection;406;0;428;0
WireConnection;406;1;405;0
WireConnection;406;2;426;0
WireConnection;427;0;404;0
WireConnection;428;0;427;0
WireConnection;414;0;443;0
WireConnection;443;0;413;0
WireConnection;443;1;434;0
WireConnection;395;0;393;0
WireConnection;434;0;413;2
WireConnection;434;1;445;0
WireConnection;411;0;402;0
WireConnection;424;0;399;0
WireConnection;445;0;435;0
WireConnection;327;0;331;0
WireConnection;327;2;329;0
WireConnection;327;3;328;0
WireConnection;469;0;472;0
WireConnection;469;2;470;0
WireConnection;469;3;327;0
WireConnection;471;0;331;0
WireConnection;472;0;471;0
WireConnection;30;0;86;0
WireConnection;30;1;122;0
WireConnection;30;2;28;0
WireConnection;29;0;30;0
WireConnection;26;0;25;0
WireConnection;35;0;34;0
WireConnection;709;21;466;0
WireConnection;709;6;249;0
WireConnection;709;10;247;0
WireConnection;709;12;248;0
WireConnection;710;21;257;0
WireConnection;710;6;255;0
WireConnection;710;10;253;0
WireConnection;710;12;254;0
WireConnection;711;21;265;0
WireConnection;711;6;262;0
WireConnection;711;10;260;0
WireConnection;711;12;261;0
WireConnection;712;21;159;0
WireConnection;712;6;205;0
WireConnection;712;10;633;0
WireConnection;713;21;172;0
WireConnection;713;6;209;0
WireConnection;713;10;637;0
WireConnection;714;21;183;0
WireConnection;714;6;213;0
WireConnection;714;10;641;0
WireConnection;715;21;270;0
WireConnection;715;6;198;0
WireConnection;715;10;629;0
WireConnection;716;21;141;0
WireConnection;716;6;202;0
WireConnection;716;10;630;0
WireConnection;717;21;164;0
WireConnection;717;6;203;0
WireConnection;717;10;631;0
WireConnection;718;21;163;0
WireConnection;718;6;204;0
WireConnection;718;10;632;0
WireConnection;719;21;160;0
WireConnection;719;6;206;0
WireConnection;719;10;634;0
WireConnection;720;21;161;0
WireConnection;720;6;207;0
WireConnection;720;10;635;0
WireConnection;721;21;162;0
WireConnection;721;6;208;0
WireConnection;721;10;636;0
WireConnection;722;21;173;0
WireConnection;722;6;212;0
WireConnection;722;10;640;0
WireConnection;723;21;170;0
WireConnection;723;6;211;0
WireConnection;723;10;639;0
WireConnection;724;21;171;0
WireConnection;724;6;210;0
WireConnection;724;10;638;0
WireConnection;725;21;184;0
WireConnection;725;6;214;0
WireConnection;725;10;642;0
WireConnection;726;21;185;0
WireConnection;726;6;215;0
WireConnection;726;10;643;0
WireConnection;727;21;186;0
WireConnection;727;6;216;0
WireConnection;727;10;644;0
WireConnection;731;0;728;0
WireConnection;731;1;729;0
WireConnection;730;0;731;0
WireConnection;25;0;736;0
WireConnection;34;0;737;0
ASEEND*/
//CHKSM=EF4E9BB788CCFD32E72AC70F264816CD6AF44887