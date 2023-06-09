&НаКлиенте
Процедура PostTest(Команда)
	//https://test.bseu.by/admin/tool/testsdatagetter/tests_execution.php?pass=34fgG$(rg&func=get_cohorts
	Соединение = Новый HTTPСоединение("test.bseu.by",443,,,,,Новый ЗащищенноеСоединениеOpenSSL);
	Заголовки = Новый Соответствие;
	//Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	Запрос = Новый HTTPЗапрос("/admin/tool/testsdatagetter/tests_execution.php?pass=34fgG$(rg&func=get_cohorts", Заголовки);
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	s = Ответ.ПолучитьТелоКакСтроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(s);
	Данные = ПрочитатьJSON(ЧтениеJSON, Истина);
	Остановка = 0;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьОценкуЗаТест(Группа, Семестр, Дисциплина)
	// Получение данных
	Соединение = Новый HTTPСоединение("test.bseu.by", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL);
	Запрос = Новый HTTPЗапрос("/admin/tool/testsdatagetter/handle_request.php?pass=34fgG$(rg&func=get_test_results&group=" + Группа + "&semester=" + Семестр + "&discipline=" + Дисциплина);
	Попытка
		Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	Исключение
		Возврат "Произошло исключение при обращении к вэб-сервису. " + ОписаниеОшибки();
	КонецПопытки;
	Если Ответ.КодСостояния <> 200 Тогда
		Возврат "Ошибка при получении данных с сервера. Код состояния = " + Ответ.КодСостояния;
	КонецЕсли;
	
	// Чтение
	ЧтениеJSON = Новый ЧтениеJSON;
	Попытка
		ЧтениеJSON.УстановитьСтроку(Ответ.ПолучитьТелоКакСтроку());
		Данные = ПрочитатьJSON(ЧтениеJSON, Ложь);
	Исключение
		Возврат "Произошло исключение чтении данных с вэб-сериса. " + ОписаниеОшибки();
	КонецПопытки;
	Возврат Данные;
КонецФункции

&НаКлиенте
Процедура ПолучитьОценкуЗаТестКоманда(Команда)
	проц_ПолучитьОценкуЗаТест()
КонецПроцедуры

&НаКлиенте
Процедура проц_ПолучитьОценкуЗаТест();
	//Данные = ПолучитьОценкуЗаТест("21РКП01", "1", "Иностранный язык");
	//Данные = ПолучитьОценкуЗаТест("21ЗФФ01", "1", "Философия");
	Данные = ПолучитьОценкуЗаТест("21РКТ0", "1", "Иностранный язык");
	Если ТипЗнч(Данные) <> Тип("Массив") Тогда
		Сообщить("Что-то пошло не так");
		Сообщить(Данные);
	КонецЕсли;
КонецПроцедуры

