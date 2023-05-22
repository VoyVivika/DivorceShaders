// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VoyVivika/DivorceShaders/Div AudioLink Overlay"
{
	Properties
	{
		_mainTex("mainTex", 2D) = "white" {}
		_normalMap("normalMap", 2D) = "bump" {}
		_MultiMap("MultiMap", 2D) = "black" {}
		_AL_Mask("AL_Mask", 2D) = "black" {}
		_Emission("Emission", 2D) = "white" {}
		_EmissionStrength("Emission Strength", Range( 0 , 1)) = 0
		_RimNormalMap("Rim Normal Map", 2D) = "bump" {}
		_RimPower("Rim Power", Range( 0 , 10)) = 2.07
		_RimEnergy("Rim Energy", Range( 0 , 1)) = 0.345
		_RimBaseColorStrength("Rim Base Color Strength", Range( 0 , 1)) = 1
		[ToggleUI]_DiscardUVTile00("Discard UV Tile 0,0", Float) = 0
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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
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
		};

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
		uniform sampler2D _normalMap;
		uniform float4 _normalMap_ST;
		uniform sampler2D _mainTex;
		uniform float4 _mainTex_ST;
		uniform sampler2D _AL_Mask;
		uniform float4 _AL_Mask_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _EmissionStrength;
		uniform sampler2D _RimNormalMap;
		uniform float _RimPower;
		uniform float _RimEnergy;
		uniform float _RimBaseColorStrength;
		uniform sampler2D _MultiMap;
		uniform float4 _MultiMap_ST;


		float IfAudioLinkv2Exists1_g13(  )
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


		inline float AudioLinkData3_g9( int Band, int Delay )
		{
			return AudioLinkData( ALPASS_AUDIOLINK + uint2( Delay, Band ) ).rrrr;
		}


		inline float AudioLinkData3_g7( int Band, int Delay )
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
			float2 break9_g20 = DiscardUV200;
			float2 temp_output_24_0_g20 = floor( float2( 0,0 ) );
			float2 break11_g20 = temp_output_24_0_g20;
			float2 break13_g20 = ( temp_output_24_0_g20 + float2( 1,1 ) );
			float ifLocalVar16_g20 = 0;
			if( break11_g20.y < break13_g20.y )
				ifLocalVar16_g20 = ( 0.0 / 0.0 );
			float ifLocalVar15_g20 = 0;
			if( break9_g20.x < break13_g20.x )
				ifLocalVar15_g20 = ifLocalVar16_g20;
			float ifLocalVar14_g20 = 0;
			if( break9_g20.y > break11_g20.y )
				ifLocalVar14_g20 = ifLocalVar15_g20;
			float ifLocalVar1_g20 = 0;
			if( break9_g20.x > break11_g20.x )
				ifLocalVar1_g20 = ifLocalVar14_g20;
			float ifLocalVar18_g20 = 0;
			if( (( _DiscardUVTile00 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g20 = ifLocalVar1_g20;
			float2 break9_g21 = DiscardUV200;
			float2 temp_output_24_0_g21 = floor( float2( 0,1 ) );
			float2 break11_g21 = temp_output_24_0_g21;
			float2 break13_g21 = ( temp_output_24_0_g21 + float2( 1,1 ) );
			float ifLocalVar16_g21 = 0;
			if( break11_g21.y < break13_g21.y )
				ifLocalVar16_g21 = ( 0.0 / 0.0 );
			float ifLocalVar15_g21 = 0;
			if( break9_g21.x < break13_g21.x )
				ifLocalVar15_g21 = ifLocalVar16_g21;
			float ifLocalVar14_g21 = 0;
			if( break9_g21.y > break11_g21.y )
				ifLocalVar14_g21 = ifLocalVar15_g21;
			float ifLocalVar1_g21 = 0;
			if( break9_g21.x > break11_g21.x )
				ifLocalVar1_g21 = ifLocalVar14_g21;
			float ifLocalVar18_g21 = 0;
			if( (( _DiscardUVTile01 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g21 = ifLocalVar1_g21;
			float2 break9_g22 = DiscardUV200;
			float2 temp_output_24_0_g22 = floor( float2( 0,2 ) );
			float2 break11_g22 = temp_output_24_0_g22;
			float2 break13_g22 = ( temp_output_24_0_g22 + float2( 1,1 ) );
			float ifLocalVar16_g22 = 0;
			if( break11_g22.y < break13_g22.y )
				ifLocalVar16_g22 = ( 0.0 / 0.0 );
			float ifLocalVar15_g22 = 0;
			if( break9_g22.x < break13_g22.x )
				ifLocalVar15_g22 = ifLocalVar16_g22;
			float ifLocalVar14_g22 = 0;
			if( break9_g22.y > break11_g22.y )
				ifLocalVar14_g22 = ifLocalVar15_g22;
			float ifLocalVar1_g22 = 0;
			if( break9_g22.x > break11_g22.x )
				ifLocalVar1_g22 = ifLocalVar14_g22;
			float ifLocalVar18_g22 = 0;
			if( (( _DiscardUVTile02 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g22 = ifLocalVar1_g22;
			float2 break9_g23 = DiscardUV200;
			float2 temp_output_24_0_g23 = floor( float2( 0,3 ) );
			float2 break11_g23 = temp_output_24_0_g23;
			float2 break13_g23 = ( temp_output_24_0_g23 + float2( 1,1 ) );
			float ifLocalVar16_g23 = 0;
			if( break11_g23.y < break13_g23.y )
				ifLocalVar16_g23 = ( 0.0 / 0.0 );
			float ifLocalVar15_g23 = 0;
			if( break9_g23.x < break13_g23.x )
				ifLocalVar15_g23 = ifLocalVar16_g23;
			float ifLocalVar14_g23 = 0;
			if( break9_g23.y > break11_g23.y )
				ifLocalVar14_g23 = ifLocalVar15_g23;
			float ifLocalVar1_g23 = 0;
			if( break9_g23.x > break11_g23.x )
				ifLocalVar1_g23 = ifLocalVar14_g23;
			float ifLocalVar18_g23 = 0;
			if( (( _DiscardUVTile03 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g23 = ifLocalVar1_g23;
			float2 break9_g24 = DiscardUV200;
			float2 temp_output_24_0_g24 = floor( float2( 1,0 ) );
			float2 break11_g24 = temp_output_24_0_g24;
			float2 break13_g24 = ( temp_output_24_0_g24 + float2( 1,1 ) );
			float ifLocalVar16_g24 = 0;
			if( break11_g24.y < break13_g24.y )
				ifLocalVar16_g24 = ( 0.0 / 0.0 );
			float ifLocalVar15_g24 = 0;
			if( break9_g24.x < break13_g24.x )
				ifLocalVar15_g24 = ifLocalVar16_g24;
			float ifLocalVar14_g24 = 0;
			if( break9_g24.y > break11_g24.y )
				ifLocalVar14_g24 = ifLocalVar15_g24;
			float ifLocalVar1_g24 = 0;
			if( break9_g24.x > break11_g24.x )
				ifLocalVar1_g24 = ifLocalVar14_g24;
			float ifLocalVar18_g24 = 0;
			if( (( _DiscardUVTile10 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g24 = ifLocalVar1_g24;
			float2 break9_g25 = DiscardUV200;
			float2 temp_output_24_0_g25 = floor( float2( 1,1 ) );
			float2 break11_g25 = temp_output_24_0_g25;
			float2 break13_g25 = ( temp_output_24_0_g25 + float2( 1,1 ) );
			float ifLocalVar16_g25 = 0;
			if( break11_g25.y < break13_g25.y )
				ifLocalVar16_g25 = ( 0.0 / 0.0 );
			float ifLocalVar15_g25 = 0;
			if( break9_g25.x < break13_g25.x )
				ifLocalVar15_g25 = ifLocalVar16_g25;
			float ifLocalVar14_g25 = 0;
			if( break9_g25.y > break11_g25.y )
				ifLocalVar14_g25 = ifLocalVar15_g25;
			float ifLocalVar1_g25 = 0;
			if( break9_g25.x > break11_g25.x )
				ifLocalVar1_g25 = ifLocalVar14_g25;
			float ifLocalVar18_g25 = 0;
			if( (( _DiscardUVTile11 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g25 = ifLocalVar1_g25;
			float2 break9_g26 = DiscardUV200;
			float2 temp_output_24_0_g26 = floor( float2( 1,2 ) );
			float2 break11_g26 = temp_output_24_0_g26;
			float2 break13_g26 = ( temp_output_24_0_g26 + float2( 1,1 ) );
			float ifLocalVar16_g26 = 0;
			if( break11_g26.y < break13_g26.y )
				ifLocalVar16_g26 = ( 0.0 / 0.0 );
			float ifLocalVar15_g26 = 0;
			if( break9_g26.x < break13_g26.x )
				ifLocalVar15_g26 = ifLocalVar16_g26;
			float ifLocalVar14_g26 = 0;
			if( break9_g26.y > break11_g26.y )
				ifLocalVar14_g26 = ifLocalVar15_g26;
			float ifLocalVar1_g26 = 0;
			if( break9_g26.x > break11_g26.x )
				ifLocalVar1_g26 = ifLocalVar14_g26;
			float ifLocalVar18_g26 = 0;
			if( (( _DiscardUVTile12 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g26 = ifLocalVar1_g26;
			float2 break9_g27 = DiscardUV200;
			float2 temp_output_24_0_g27 = floor( float2( 1,3 ) );
			float2 break11_g27 = temp_output_24_0_g27;
			float2 break13_g27 = ( temp_output_24_0_g27 + float2( 1,1 ) );
			float ifLocalVar16_g27 = 0;
			if( break11_g27.y < break13_g27.y )
				ifLocalVar16_g27 = ( 0.0 / 0.0 );
			float ifLocalVar15_g27 = 0;
			if( break9_g27.x < break13_g27.x )
				ifLocalVar15_g27 = ifLocalVar16_g27;
			float ifLocalVar14_g27 = 0;
			if( break9_g27.y > break11_g27.y )
				ifLocalVar14_g27 = ifLocalVar15_g27;
			float ifLocalVar1_g27 = 0;
			if( break9_g27.x > break11_g27.x )
				ifLocalVar1_g27 = ifLocalVar14_g27;
			float ifLocalVar18_g27 = 0;
			if( (( _DiscardUVTile13 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g27 = ifLocalVar1_g27;
			float2 break9_g28 = DiscardUV200;
			float2 temp_output_24_0_g28 = floor( float2( 2,0 ) );
			float2 break11_g28 = temp_output_24_0_g28;
			float2 break13_g28 = ( temp_output_24_0_g28 + float2( 1,1 ) );
			float ifLocalVar16_g28 = 0;
			if( break11_g28.y < break13_g28.y )
				ifLocalVar16_g28 = ( 0.0 / 0.0 );
			float ifLocalVar15_g28 = 0;
			if( break9_g28.x < break13_g28.x )
				ifLocalVar15_g28 = ifLocalVar16_g28;
			float ifLocalVar14_g28 = 0;
			if( break9_g28.y > break11_g28.y )
				ifLocalVar14_g28 = ifLocalVar15_g28;
			float ifLocalVar1_g28 = 0;
			if( break9_g28.x > break11_g28.x )
				ifLocalVar1_g28 = ifLocalVar14_g28;
			float ifLocalVar18_g28 = 0;
			if( (( _DiscardUVTile20 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g28 = ifLocalVar1_g28;
			float2 break9_g29 = DiscardUV200;
			float2 temp_output_24_0_g29 = floor( float2( 2,1 ) );
			float2 break11_g29 = temp_output_24_0_g29;
			float2 break13_g29 = ( temp_output_24_0_g29 + float2( 1,1 ) );
			float ifLocalVar16_g29 = 0;
			if( break11_g29.y < break13_g29.y )
				ifLocalVar16_g29 = ( 0.0 / 0.0 );
			float ifLocalVar15_g29 = 0;
			if( break9_g29.x < break13_g29.x )
				ifLocalVar15_g29 = ifLocalVar16_g29;
			float ifLocalVar14_g29 = 0;
			if( break9_g29.y > break11_g29.y )
				ifLocalVar14_g29 = ifLocalVar15_g29;
			float ifLocalVar1_g29 = 0;
			if( break9_g29.x > break11_g29.x )
				ifLocalVar1_g29 = ifLocalVar14_g29;
			float ifLocalVar18_g29 = 0;
			if( (( _DiscardUVTile21 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g29 = ifLocalVar1_g29;
			float2 break9_g30 = DiscardUV200;
			float2 temp_output_24_0_g30 = floor( float2( 2,2 ) );
			float2 break11_g30 = temp_output_24_0_g30;
			float2 break13_g30 = ( temp_output_24_0_g30 + float2( 1,1 ) );
			float ifLocalVar16_g30 = 0;
			if( break11_g30.y < break13_g30.y )
				ifLocalVar16_g30 = ( 0.0 / 0.0 );
			float ifLocalVar15_g30 = 0;
			if( break9_g30.x < break13_g30.x )
				ifLocalVar15_g30 = ifLocalVar16_g30;
			float ifLocalVar14_g30 = 0;
			if( break9_g30.y > break11_g30.y )
				ifLocalVar14_g30 = ifLocalVar15_g30;
			float ifLocalVar1_g30 = 0;
			if( break9_g30.x > break11_g30.x )
				ifLocalVar1_g30 = ifLocalVar14_g30;
			float ifLocalVar18_g30 = 0;
			if( (( _DiscardUVTile22 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g30 = ifLocalVar1_g30;
			float2 break9_g31 = DiscardUV200;
			float2 temp_output_24_0_g31 = floor( float2( 2,3 ) );
			float2 break11_g31 = temp_output_24_0_g31;
			float2 break13_g31 = ( temp_output_24_0_g31 + float2( 1,1 ) );
			float ifLocalVar16_g31 = 0;
			if( break11_g31.y < break13_g31.y )
				ifLocalVar16_g31 = ( 0.0 / 0.0 );
			float ifLocalVar15_g31 = 0;
			if( break9_g31.x < break13_g31.x )
				ifLocalVar15_g31 = ifLocalVar16_g31;
			float ifLocalVar14_g31 = 0;
			if( break9_g31.y > break11_g31.y )
				ifLocalVar14_g31 = ifLocalVar15_g31;
			float ifLocalVar1_g31 = 0;
			if( break9_g31.x > break11_g31.x )
				ifLocalVar1_g31 = ifLocalVar14_g31;
			float ifLocalVar18_g31 = 0;
			if( (( _DiscardUVTile23 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g31 = ifLocalVar1_g31;
			float2 break9_g35 = DiscardUV200;
			float2 temp_output_24_0_g35 = floor( float2( 3,0 ) );
			float2 break11_g35 = temp_output_24_0_g35;
			float2 break13_g35 = ( temp_output_24_0_g35 + float2( 1,1 ) );
			float ifLocalVar16_g35 = 0;
			if( break11_g35.y < break13_g35.y )
				ifLocalVar16_g35 = ( 0.0 / 0.0 );
			float ifLocalVar15_g35 = 0;
			if( break9_g35.x < break13_g35.x )
				ifLocalVar15_g35 = ifLocalVar16_g35;
			float ifLocalVar14_g35 = 0;
			if( break9_g35.y > break11_g35.y )
				ifLocalVar14_g35 = ifLocalVar15_g35;
			float ifLocalVar1_g35 = 0;
			if( break9_g35.x > break11_g35.x )
				ifLocalVar1_g35 = ifLocalVar14_g35;
			float ifLocalVar18_g35 = 0;
			if( (( _DiscardUVTile30 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g35 = ifLocalVar1_g35;
			float2 break9_g34 = DiscardUV200;
			float2 temp_output_24_0_g34 = floor( float2( 3,1 ) );
			float2 break11_g34 = temp_output_24_0_g34;
			float2 break13_g34 = ( temp_output_24_0_g34 + float2( 1,1 ) );
			float ifLocalVar16_g34 = 0;
			if( break11_g34.y < break13_g34.y )
				ifLocalVar16_g34 = ( 0.0 / 0.0 );
			float ifLocalVar15_g34 = 0;
			if( break9_g34.x < break13_g34.x )
				ifLocalVar15_g34 = ifLocalVar16_g34;
			float ifLocalVar14_g34 = 0;
			if( break9_g34.y > break11_g34.y )
				ifLocalVar14_g34 = ifLocalVar15_g34;
			float ifLocalVar1_g34 = 0;
			if( break9_g34.x > break11_g34.x )
				ifLocalVar1_g34 = ifLocalVar14_g34;
			float ifLocalVar18_g34 = 0;
			if( (( _DiscardUVTile31 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g34 = ifLocalVar1_g34;
			float2 break9_g33 = DiscardUV200;
			float2 temp_output_24_0_g33 = floor( float2( 3,2 ) );
			float2 break11_g33 = temp_output_24_0_g33;
			float2 break13_g33 = ( temp_output_24_0_g33 + float2( 1,1 ) );
			float ifLocalVar16_g33 = 0;
			if( break11_g33.y < break13_g33.y )
				ifLocalVar16_g33 = ( 0.0 / 0.0 );
			float ifLocalVar15_g33 = 0;
			if( break9_g33.x < break13_g33.x )
				ifLocalVar15_g33 = ifLocalVar16_g33;
			float ifLocalVar14_g33 = 0;
			if( break9_g33.y > break11_g33.y )
				ifLocalVar14_g33 = ifLocalVar15_g33;
			float ifLocalVar1_g33 = 0;
			if( break9_g33.x > break11_g33.x )
				ifLocalVar1_g33 = ifLocalVar14_g33;
			float ifLocalVar18_g33 = 0;
			if( (( _DiscardUVTile32 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g33 = ifLocalVar1_g33;
			float2 break9_g32 = DiscardUV200;
			float2 temp_output_24_0_g32 = floor( float2( 3,3 ) );
			float2 break11_g32 = temp_output_24_0_g32;
			float2 break13_g32 = ( temp_output_24_0_g32 + float2( 1,1 ) );
			float ifLocalVar16_g32 = 0;
			if( break11_g32.y < break13_g32.y )
				ifLocalVar16_g32 = ( 0.0 / 0.0 );
			float ifLocalVar15_g32 = 0;
			if( break9_g32.x < break13_g32.x )
				ifLocalVar15_g32 = ifLocalVar16_g32;
			float ifLocalVar14_g32 = 0;
			if( break9_g32.y > break11_g32.y )
				ifLocalVar14_g32 = ifLocalVar15_g32;
			float ifLocalVar1_g32 = 0;
			if( break9_g32.x > break11_g32.x )
				ifLocalVar1_g32 = ifLocalVar14_g32;
			float ifLocalVar18_g32 = 0;
			if( (( _DiscardUVTile33 )?( 1.0 ):( 0.0 )) == 1.0 )
				ifLocalVar18_g32 = ifLocalVar1_g32;
			float UVTileDiscard192 = ( ( ifLocalVar18_g20 + ifLocalVar18_g21 + ifLocalVar18_g22 + ifLocalVar18_g23 ) + ( ifLocalVar18_g24 + ifLocalVar18_g25 + ifLocalVar18_g26 + ifLocalVar18_g27 ) + ( ifLocalVar18_g28 + ifLocalVar18_g29 + ifLocalVar18_g30 + ifLocalVar18_g31 ) + ( ifLocalVar18_g35 + ifLocalVar18_g34 + ifLocalVar18_g33 + ifLocalVar18_g32 ) );
			float3 temp_cast_0 = (UVTileDiscard192).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_normalMap = i.uv_texcoord * _normalMap_ST.xy + _normalMap_ST.zw;
			float3 normalMap35 = UnpackNormal( tex2D( _normalMap, uv_normalMap ) );
			o.Normal = normalMap35;
			float2 uv_mainTex = i.uv_texcoord * _mainTex_ST.xy + _mainTex_ST.zw;
			float4 mainTex26 = tex2D( _mainTex, uv_mainTex );
			o.Albedo = mainTex26.rgb;
			float2 uv_AL_Mask = i.uv_texcoord * _AL_Mask_ST.xy + _AL_Mask_ST.zw;
			float4 ALMask39 = tex2D( _AL_Mask, uv_AL_Mask );
			float localIfAudioLinkv2Exists1_g13 = IfAudioLinkv2Exists1_g13();
			float4 color42 = IsGammaSpace() ? float4(1,0,0,1) : float4(1,0,0,1);
			float3 hsvTorgb4_g36 = RGBToHSV( color42.rgb );
			float mulTime48 = _Time.y * 0.1;
			float Time50 = frac( mulTime48 );
			float3 hsvTorgb8_g36 = HSVToRGB( float3(( hsvTorgb4_g36.x + Time50 ),( hsvTorgb4_g36.y + 0.0 ),( hsvTorgb4_g36.z + 0.0 )) );
			float3 temp_output_194_0 = saturate( hsvTorgb8_g36 );
			int Band3_g4 = 0;
			int Delay3_g4 = 0;
			float localAudioLinkData3_g4 = AudioLinkData3_g4( Band3_g4 , Delay3_g4 );
			float3 ifLocalVar125 = 0;
			if( localIfAudioLinkv2Exists1_g13 == 1.0 )
				ifLocalVar125 = ( temp_output_194_0 * localAudioLinkData3_g4 );
			else if( localIfAudioLinkv2Exists1_g13 < 1.0 )
				ifLocalVar125 = temp_output_194_0;
			float3 ALC_Bass61 = ifLocalVar125;
			float4 color44 = IsGammaSpace() ? float4(0,0.8196079,0,1) : float4(0,0.637597,0,1);
			float3 hsvTorgb4_g39 = RGBToHSV( color44.rgb );
			float3 hsvTorgb8_g39 = HSVToRGB( float3(( hsvTorgb4_g39.x + Time50 ),( hsvTorgb4_g39.y + 0.0 ),( hsvTorgb4_g39.z + 0.0 )) );
			int Band3_g9 = 2;
			int Delay3_g9 = 0;
			float localAudioLinkData3_g9 = AudioLinkData3_g9( Band3_g9 , Delay3_g9 );
			float3 ALC_HighMid67 = ( saturate( hsvTorgb8_g39 ) * localAudioLinkData3_g9 );
			float4 color43 = IsGammaSpace() ? float4(1,0.9294118,0,1) : float4(1,0.8468735,0,1);
			float3 hsvTorgb4_g38 = RGBToHSV( color43.rgb );
			float3 hsvTorgb8_g38 = HSVToRGB( float3(( hsvTorgb4_g38.x + Time50 ),( hsvTorgb4_g38.y + 0.0 ),( hsvTorgb4_g38.z + 0.0 )) );
			int Band3_g7 = 1;
			int Delay3_g7 = 0;
			float localAudioLinkData3_g7 = AudioLinkData3_g7( Band3_g7 , Delay3_g7 );
			float3 ALC_LowMid64 = ( saturate( hsvTorgb8_g38 ) * localAudioLinkData3_g7 );
			float4 color45 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
			float3 hsvTorgb4_g37 = RGBToHSV( color45.rgb );
			float3 hsvTorgb8_g37 = HSVToRGB( float3(( hsvTorgb4_g37.x + Time50 ),( hsvTorgb4_g37.y + 0.0 ),( hsvTorgb4_g37.z + 0.0 )) );
			int Band3_g11 = 3;
			int Delay3_g11 = 0;
			float localAudioLinkData3_g11 = AudioLinkData3_g11( Band3_g11 , Delay3_g11 );
			float3 ALC_Treble70 = ( saturate( hsvTorgb8_g37 ) * localAudioLinkData3_g11 );
			float4 AL_Final85 = ( ( ALMask39 * float4( ALC_Bass61 , 0.0 ) ) + ( ALMask39 * float4( ALC_HighMid67 , 0.0 ) ) + ( ALMask39 * float4( ALC_LowMid64 , 0.0 ) ) + ( ALMask39 * float4( ALC_Treble70 , 0.0 ) ) );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 Emission119 = ( tex2D( _Emission, uv_Emission ) * _EmissionStrength );
			float3 normalizeResult9 = normalize( i.viewDir );
			float dotResult10 = dot( UnpackNormal( tex2D( _RimNormalMap, i.uv_texcoord ) ) , normalizeResult9 );
			float Rim16 = ( pow( ( 1.0 - saturate( dotResult10 ) ) , ( 10.0 - _RimPower ) ) * _RimEnergy );
			float4 lerpResult114 = lerp( float4( 1,1,1,0 ) , mainTex26 , _RimBaseColorStrength);
			float4 Rim116 = ( Rim16 * lerpResult114 );
			float4 EmissionFinal29 = ( AL_Final85 + Emission119 + Rim116 );
			o.Emission = EmissionFinal29.rgb;
			float2 uv_MultiMap = i.uv_texcoord * _MultiMap_ST.xy + _MultiMap_ST.zw;
			float4 multiMap90 = tex2D( _MultiMap, uv_MultiMap );
			float4 break95 = multiMap90;
			o.Metallic = break95;
			o.Smoothness = break95.g;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Node;AmplifyShaderEditor.CommentaryNode;220;2051.233,-3370.865;Inherit;False;962.8354;715.8684;Comment;7;0;33;36;32;95;92;193;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;201;-55.94421,-697.3302;Inherit;False;503.0845;214.413;Comment;2;200;199;Discard UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;107;-23.66935,-4536.875;Inherit;False;903.0725;942.8996;Comment;14;85;84;83;82;81;80;79;78;76;77;75;74;73;71;AudioLink Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;106;-112.9787,-5381.73;Inherit;False;1183.572;355.2229;Comment;5;57;69;68;70;45;AudioLink Treble;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;105;-86.35403,-5893.254;Inherit;False;1188.215;403.241;Comment;5;67;65;66;56;44;AudioLink HighMid;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-1337.905,-5407.259;Inherit;False;1137.62;367.6456;Comment;5;64;63;62;55;43;AudioLink LowMid;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;103;-1337.02,-5897.206;Inherit;False;1176.516;390.1733;Comment;7;42;61;125;41;124;58;51;AudioLink Bass;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;72;-1745.04,-4819.045;Inherit;False;641.9634;172.3457;Comment;3;49;48;50;Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1965.349,-2029.931;Inherit;False;628.8561;285.3137;Comment;2;35;34;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-636.0011,-1983.635;Inherit;False;737.2792;402.4306;Comment;5;29;86;28;30;122;Emission Combination;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-1891.004,-2474.635;Inherit;False;604.8932;280;Comment;2;25;26;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;-2900.365,-615.0645;Inherit;False;2284.93;937.6693;Comment;18;4;116;113;114;112;115;87;8;9;10;88;16;12;7;15;14;13;11;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;21;-2001.234,-1099.6;Inherit;False;606.1929;168.3132;Comment;2;22;23;Speed;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1621.164,-1049.6;Float;False;Speed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1944.234,-1039.374;Float;False;Property;_Speed;Speed;0;0;Create;True;0;0;0;False;0;False;26;26;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-1560.493,-1979.931;Inherit;False;normalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1849.337,-3502.624;Inherit;False;604.8932;280;Comment;2;40;39;AL Emission Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.FractNode;49;-1506.809,-4769.045;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-1327.076,-4762.699;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1510.111,-2420.833;Inherit;False;mainTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;25;-1835.004,-2418.635;Inherit;True;Property;_mainTex;mainTex;1;0;Create;True;0;0;0;False;0;False;-1;0db631ddb1a2c1443b81c6ac5ce43d11;0db631ddb1a2c1443b81c6ac5ce43d11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
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
Node;AmplifyShaderEditor.GetLocalVarNode;86;-594.7267,-1906.872;Inherit;False;85;AL_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-1471.095,-3451.473;Inherit;False;ALMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;117;-1853.104,-2983.999;Inherit;False;791.7242;362.8555;Comment;4;120;119;118;121;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;118;-1797.104,-2926.999;Inherit;True;Property;_Emission;Emission;5;0;Create;True;0;0;0;False;0;False;-1;83f90c05f51ea5c469ceb2c4218b09a7;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-1276.658,-2924.725;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-1771.553,-2723.966;Inherit;False;Property;_EmissionStrength;Emission Strength;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-1444.109,-2847.282;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-339.5763,-1838.825;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-114.9731,-1846.543;Inherit;False;EmissionFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-593.0291,-1816.919;Inherit;False;119;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-594.8048,-1719.686;Inherit;False;116;Rim;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;11;-2064.503,-341.7383;Inherit;False;1;0;FLOAT;1.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;13;-1895.499,-299.439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-2119.493,-214.1308;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-1702.701,-276.0385;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;7;-2665.201,-289.4382;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;12;-2535.331,-129.8415;Float;False;Property;_RimPower;Rim Power;8;0;Create;True;0;0;0;False;0;False;2.07;3.39;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1291.625,-319.9706;Float;True;Rim;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1494.975,-240.4371;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;10;-2283.137,-442.4546;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;9;-2453.95,-280.8707;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;8;-2605.283,-526.4305;Inherit;True;Property;_RimNormalMap;Rim Normal Map;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-1778.779,-116.7007;Inherit;False;Property;_RimEnergy;Rim Energy;9;0;Create;True;0;0;0;False;0;False;0.345;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-1064.095,-150.3588;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-1530.281,62.00417;Inherit;False;26;mainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1650.69,160.1974;Inherit;False;Property;_RimBaseColorStrength;Rim Base Color Strength;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-856.0953,-166.3588;Float;True;Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2842.348,-498.1891;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;114;-1326.234,9.717422;Inherit;True;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;40;-1793.337,-3445.624;Inherit;True;Property;_AL_Mask;AL_Mask;4;0;Create;True;0;0;0;False;0;False;-1;83f90c05f51ea5c469ceb2c4218b09a7;83f90c05f51ea5c469ceb2c4218b09a7;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;91;-795.4411,-2748.33;Inherit;True;Property;_MultiMap;MultiMap;3;0;Create;True;0;0;0;False;0;False;-1;01e8d4996fddd0a448744957657de587;01e8d4996fddd0a448744957657de587;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-1915.349,-1974.617;Inherit;True;Property;_normalMap;normalMap;2;0;Create;True;0;0;0;False;0;False;-1;13ce54de7ec2bdd45a3ceb8a5e5e4cad;1f3982b36e89bca46b80f47660759b39;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;48;-1695.04,-4768.258;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1247.875,-5610.916;Inherit;False;50;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-735.7633,-5741.359;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;41;-1052.972,-5786.569;Inherit;False;4BandAmplitude;-1;;4;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-367.5052,-5782.771;Inherit;False;ALC_Bass;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;42;-1312.543,-5798.206;Inherit;False;Constant;_AL_Bass;AL_Bass;6;0;Create;True;0;0;0;False;0;False;1,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;68;343.0645,-5166.744;Inherit;False;4BandAmplitude;-1;;11;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;3;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;-1294.715,-5338.324;Inherit;False;Constant;_AL_LowMid;AL_LowMid;6;0;Create;True;0;0;0;False;0;False;1,0.9294118,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1102.38,-5249.526;Inherit;False;50;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;62;-919.6196,-5182.47;Inherit;False;4BandAmplitude;-1;;7;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;1;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-644.6395,-5299.407;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-415.1543,-5306.091;Inherit;False;ALC_LowMid;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;44;-54.51395,-5792.144;Inherit;False;Constant;_AL_HighMid;AL_HighMid;6;0;Create;True;0;0;0;False;0;False;0,0.8196079,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;56;141.1703,-5704.85;Inherit;False;50;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;665.2375,-5831.361;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;65;362.9142,-5666.229;Inherit;False;4BandAmplitude;-1;;9;f5073bb9076c4e24481a28578c80bed5;0;2;2;INT;2;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;879.6917,-5819.153;Inherit;False;ALC_HighMid;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;124;-747.4884,-5834.831;Inherit;False;IsAudioLink;-1;;13;e83fef6181013ba4bacf30a3d9a31d37;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;125;-536.8116,-5774.364;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;675.2438,-4163.689;Inherit;False;AL_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;138;924.1055,-995.565;Inherit;False;3964.762;1737.559;Comment;58;191;225;224;192;223;222;216;215;214;213;212;211;210;209;205;206;208;207;204;203;202;198;190;189;188;187;186;185;184;183;180;177;176;175;174;173;172;171;170;167;164;163;162;161;160;159;158;157;156;155;154;149;148;147;146;145;143;141;UV Tile Discard;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;141;990.0652,-360.4861;Inherit;False;Property;_DiscardUVTile01;Discard UV Tile 0,1;12;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;143;990.8054,-582.2604;Inherit;False;Property;_DiscardUVTile00;Discard UV Tile 0,0;11;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;145;1250.798,-534.1523;Inherit;False;UV Tile Discard;-1;;20;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;146;1249.957,-302.1618;Inherit;False;UV Tile Discard;-1;;21;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;147;1237.957,-35.16182;Inherit;False;UV Tile Discard;-1;;22;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;148;1242.957,208.8371;Inherit;False;UV Tile Discard;-1;;23;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;0,3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;1574.041,-29.37679;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;2361.4,4.925166;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;155;2012.833,-517.0515;Inherit;False;UV Tile Discard;-1;;24;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;1,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;156;2009.993,-288.0609;Inherit;False;UV Tile Discard;-1;;25;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;1,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;157;2001.993,-18.06081;Inherit;False;UV Tile Discard;-1;;26;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;1,2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;158;2005.993,224.9392;Inherit;False;UV Tile Discard;-1;;27;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;1,3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;159;1754.841,-567.1594;Inherit;False;Property;_DiscardUVTile10;Discard UV Tile 1,0;15;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;160;1752.101,-344.385;Inherit;False;Property;_DiscardUVTile11;Discard UV Tile 1,1;16;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;161;1737.141,-81.18752;Inherit;False;Property;_DiscardUVTile12;Discard UV Tile 1,2;17;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;162;1744.043,166.4292;Inherit;False;Property;_DiscardUVTile13;Discard UV Tile 1,3;18;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;163;981.0068,150.3282;Inherit;False;Property;_DiscardUVTile03;Discard UV Tile 0,3;14;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;164;974.1055,-96.28862;Inherit;False;Property;_DiscardUVTile02;Discard UV Tile 0,2;13;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;167;3157.587,-121.3273;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;170;2533.325,-70.9969;Inherit;False;Property;_DiscardUVTile22;Discard UV Tile 2,2;21;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;171;2533.454,-310.4654;Inherit;False;Property;_DiscardUVTile21;Discard UV Tile 2,1;20;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;172;2538.16,-548.0706;Inherit;False;Property;_DiscardUVTile20;Discard UV Tile 2,0;19;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;173;2540.226,176.6202;Inherit;False;Property;_DiscardUVTile23;Discard UV Tile 2,3;22;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;174;2794.187,-480.5318;Inherit;False;UV Tile Discard;-1;;28;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;2,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;175;2791.713,-255.4414;Inherit;False;UV Tile Discard;-1;;29;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;2,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;176;2794.278,-11.77077;Inherit;False;UV Tile Discard;-1;;30;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;2,2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;177;2802.178,235.1292;Inherit;False;UV Tile Discard;-1;;31;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;2,3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;3952.679,-123.3625;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;183;3333.252,-550.1058;Inherit;False;Property;_DiscardUVTile30;Discard UV Tile 3,0;23;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;184;3328.546,-312.5008;Inherit;False;Property;_DiscardUVTile31;Discard UV Tile 3,1;24;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;185;3328.417,-72.03218;Inherit;False;Property;_DiscardUVTile32;Discard UV Tile 3,2;25;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;186;3335.318,174.5842;Inherit;False;Property;_DiscardUVTile33;Discard UV Tile 3,3;26;0;Create;True;0;0;0;False;0;False;0;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;187;3597.27,233.0932;Inherit;False;UV Tile Discard;-1;;32;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;3,3;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;188;3589.37,-13.80581;Inherit;False;UV Tile Discard;-1;;33;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;3,2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;189;3586.805,-257.4768;Inherit;False;UV Tile Discard;-1;;34;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;3,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;190;3589.279,-482.5672;Inherit;False;UV Tile Discard;-1;;35;f1bd11510c44bc348aeb983c4528c9d5;0;3;21;FLOAT;0;False;6;FLOAT2;0,0;False;10;FLOAT2;3,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;194;-1058.552,-5678.013;Inherit;False;HueShift;-1;;36;09c7357f8ce789c46a405a6704ca8341;0;4;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;195;343.6559,-5323.875;Inherit;False;HueShift;-1;;37;09c7357f8ce789c46a405a6704ca8341;0;4;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;196;-907.4175,-5335.405;Inherit;False;HueShift;-1;;38;09c7357f8ce789c46a405a6704ca8341;0;4;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;197;368.8238,-5818.455;Inherit;False;HueShift;-1;;39;09c7357f8ce789c46a405a6704ca8341;0;4;14;COLOR;0,0,0,0;False;15;FLOAT;0;False;16;FLOAT;0;False;17;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;1008.975,-462.4355;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;1004.224,-253.9884;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;988.2236,27.0116;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;1010.224,281.0116;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;1757.114,54.38696;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;1767.015,285.4188;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;1766.864,-211.7507;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;205;1765.512,-459.5844;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;2561.651,-432.2817;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;210;2542.959,-186.1652;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;2562.69,53.72052;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;2560.612,296.7217;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;3334.27,-413.5894;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;3360.231,-180.973;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;3356.078,48.52803;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;3341.539,286.3369;Inherit;False;200;DiscardUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;217;3228.887,-4815.999;Inherit;False;420.8079;185;Comment;2;219;218;Declare NaN;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;218;3278.887,-4765.999;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;219;3425.695,-4764.384;Inherit;False;NaN;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2759.068,-3220.523;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;VoyVivika/DivorceShaders/Div AudioLink Overlay;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;1;Include;Assets/AudioLink/Shaders/AudioLink.cginc;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;2286.262,-3320.865;Inherit;False;26;mainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;2297.222,-3237.719;Inherit;False;35;normalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;2301.754,-3145.94;Inherit;False;29;EmissionFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;95;2282.518,-3022.374;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;92;2101.233,-3026.873;Inherit;False;90;multiMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;2468.81,-2770.997;Inherit;False;192;UVTileDiscard;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;225;1676.254,-711.4808;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;192;4647.759,-868.7963;Inherit;False;UVTileDiscard;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;4344.228,-842.1623;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;223;3297.711,-620.9256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;222;4090.643,-609.0677;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;224;2511.907,-670.8979;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;223.1403,-647.3302;Inherit;False;DiscardUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;199;-5.944214,-641.9172;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;23;0;22;0
WireConnection;35;0;34;0
WireConnection;49;0;48;0
WireConnection;50;0;49;0
WireConnection;26;0;25;0
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
WireConnection;30;0;86;0
WireConnection;30;1;122;0
WireConnection;30;2;28;0
WireConnection;29;0;30;0
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
WireConnection;116;0;115;0
WireConnection;114;1;112;0
WireConnection;114;2;113;0
WireConnection;58;0;194;0
WireConnection;58;1;41;0
WireConnection;61;0;125;0
WireConnection;63;0;196;0
WireConnection;63;1;62;0
WireConnection;64;0;63;0
WireConnection;66;0;197;0
WireConnection;66;1;65;0
WireConnection;67;0;66;0
WireConnection;125;0;124;0
WireConnection;125;3;58;0
WireConnection;125;4;194;0
WireConnection;85;0;84;0
WireConnection;145;21;143;0
WireConnection;145;6;198;0
WireConnection;146;21;141;0
WireConnection;146;6;202;0
WireConnection;147;21;164;0
WireConnection;147;6;203;0
WireConnection;148;21;163;0
WireConnection;148;6;204;0
WireConnection;149;0;145;0
WireConnection;149;1;146;0
WireConnection;149;2;147;0
WireConnection;149;3;148;0
WireConnection;154;0;155;0
WireConnection;154;1;156;0
WireConnection;154;2;157;0
WireConnection;154;3;158;0
WireConnection;155;21;159;0
WireConnection;155;6;205;0
WireConnection;156;21;160;0
WireConnection;156;6;206;0
WireConnection;157;21;161;0
WireConnection;157;6;207;0
WireConnection;158;21;162;0
WireConnection;158;6;208;0
WireConnection;167;0;174;0
WireConnection;167;1;175;0
WireConnection;167;2;176;0
WireConnection;167;3;177;0
WireConnection;174;21;172;0
WireConnection;174;6;209;0
WireConnection;175;21;171;0
WireConnection;175;6;210;0
WireConnection;176;21;170;0
WireConnection;176;6;211;0
WireConnection;177;21;173;0
WireConnection;177;6;212;0
WireConnection;180;0;190;0
WireConnection;180;1;189;0
WireConnection;180;2;188;0
WireConnection;180;3;187;0
WireConnection;187;21;186;0
WireConnection;187;6;216;0
WireConnection;188;21;185;0
WireConnection;188;6;215;0
WireConnection;189;21;184;0
WireConnection;189;6;214;0
WireConnection;190;21;183;0
WireConnection;190;6;213;0
WireConnection;194;14;42;0
WireConnection;194;15;51;0
WireConnection;195;14;45;0
WireConnection;195;15;57;0
WireConnection;196;14;43;0
WireConnection;196;15;55;0
WireConnection;197;14;44;0
WireConnection;197;15;56;0
WireConnection;219;0;218;0
WireConnection;0;0;33;0
WireConnection;0;1;36;0
WireConnection;0;2;32;0
WireConnection;0;3;95;0
WireConnection;0;4;95;1
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
ASEEND*/
//CHKSM=5EA6BB99E2D6CF0F8518355CED5A05D5E8608061