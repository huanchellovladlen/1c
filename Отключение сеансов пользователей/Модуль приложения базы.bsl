Процедура ПриНачалеРаботыСистемы()
	КлиентскоеПриложение.УстановитьЗаголовок(СерверныеМеханизмы.ПолучитьНазваниеОрганизации());
	ИмяПользователя = ИмяПользователя();
	Если ИмяПользователя <> "Администратор" Тогда
		ПодключитьОбработчикОжидания("ОтключениеПользователей", 20,); // 20 - 20 секунд
	КонецЕсли;
КонецПроцедуры

Процедура ОтключениеПользователей() Экспорт
	Если СерверныеМеханизмы.ПолучитьОтключитьПользователей() = Истина Тогда
		Предупреждение("Вас отключат через 10 секунд.", 10, "Предупреждение администратора");
		ЗавершитьРаботуСистемы();
	КонецЕсли;
	Если СерверныеМеханизмы.ПолучитьПослатьПредупреждениеОтключения() = Истина Тогда
		ТестПредупреждения = СерверныеМеханизмы.ПолучитьТекстПредупреждения();
		ТестПредупреждения = ?(ТестПредупреждения = "",
			"Внимание. В скором времени будут произвродится технические работы с базой. Пожалуйста, сохраните изменения в документах и выйдите.", 
			ТестПредупреждения);
		Предупреждение(ТестПредупреждения, 10, "Предупреждение администратора");
	КонецЕсли;
КонецПроцедуры

Процедура ПередНачаломРаботыСистемы(Отказ)
	Если ИмяПользователя() <> "Администратор" И СерверныеМеханизмы.ПолучитьОтключитьПользователей() = Истина Тогда
		ТестПредупреждения = СерверныеМеханизмы.ПолучитьТекстПредупрежденияДляНовых();
		ТестПредупреждения = ?(ТестПредупреждения = "", "В данный момент ведутся технические работы с базой данных", ТестПредупреждения);
		Предупреждение(ТестПредупреждения,, "Предупреждение администратора");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры
