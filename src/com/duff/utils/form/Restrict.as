package com.duff.utils.form
{


	public class Restrict 
	{
		
		/**
		 * Restricted chars of a name prop
		 */
		static public const NAME		: String = "A-Za-z 0-9´^~`";
		
		/**
		 * Restricted chars of a email prop
		 */
		static public const EMAIL		: String = "A-Za-z@\\-\\_.0-9";
		
		/**
		 * Restricted chars of a birthdate prop
		 */
		static public const BIRTHDATE	: String = "0-9\\/\\.";
		
		/**
		 * Restricted chars of a cpf prop
		 */
		static public const CPF			: String = "0-9\\-\\.";
		
		/**
		 * Restricted chars of a cnpj prop
		 */
		static public const CNPJ		: String = "0-9\\-\\.";
		
		/**
		 * Restricted chars of a rg prop
		 */
		static public const RG			: String = "0-9";
		
		/**
		 * Restricted chars of a ddd prop
		 */
		static public const DDD			: String = "0-9";
		
		/**
		 * Restricted chars of a phone prop
		 */
		static public const PHONE		: String = "0-9";
		
		/**
		 * Restricted chars of a foot number prop
		 */
		static public const FOOT_NUMBER	: String = "0-9";
		
		/**
		 * Restricted chars of a cep prop
		 */
		static public const CEP			: String = "0-9\\-\\";
	}
}

