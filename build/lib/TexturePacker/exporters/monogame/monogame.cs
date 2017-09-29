/*
 * Class auto generated by TexturePacker
 * 
 * Contains references to each image within the sprite sheet.
 *
 * http://www.codeandweb.com/texturepacker
 * {{smartUpdateKey}}
 *
 */{% load TransformName %}
namespace TexturePackerMonoGameDefinitions
{
	public class {{settings.tpsName}}
	{
{% for sprite in allSprites %}		public const string {{sprite.trimmedName|stripPathSeparators}} = "{{sprite.trimmedName}}";
{% endfor %}	}
}