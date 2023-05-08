#Область РезервноеКопирование

&НаСервере
Функция ЗагрузитьРезервнуюКопиюНаСервере()
	Группа = Справочники.Файлы.НайтиПоНаименованию("РезервныеКопииПланов", Истина, Справочники.Файлы.ПустаяСсылка());
	Если Группа.Пустая() Тогда
		Возврат "Резервная копия ещё не создавалась";
	КонецЕсли;
	ДокФайл = Справочники.Файлы.НайтиПоНаименованию(Объект.Кафедра.Наименование, Истина, Группа);
	Если ДокФайл.Пустая() Тогда
		Возврат "Резервная копия ещё не создавалась";
	КонецЕсли;

	Данные = ДокФайл.ДанныеФайла.Получить();
	XMLСтрока = ПолучитьСтрокуИзДвоичныхДанных(Данные, КодировкаТекста.UTF8);
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(XMLСтрока);
	Документ = ПрочитатьXML(Чтение);
	Документ.Дата = ТекущаяДата();
	Документ.Записать(РежимЗаписиДокумента.Запись);
КонецФункции

&НаКлиенте
Процедура ЗагрузитьРезервнуюКопию(Команда)
	Сообщить("Диалог ""Вы точно хотите загрузить копию из бэкапа?""");
	Результат = ЗагрузитьРезервнуюКопиюНаСервере();
	Если Результат = Неопределено Тогда
		ПоказатьПредупреждение(, "Резервная копия успешно загружена!" + Символы.ПС + "Пожалуйста, откройте документ ещё раз");
		ЭтаФорма.Закрыть();
	Иначе
		ПоказатьПредупреждение(, Результат, 0);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СохранитьРезервнуюКопиюНаСервере()
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.УстановитьСтроку();
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписатьXML(ЗаписьXML, Объект.Ссылка.ПолучитьОбъект());
	СтрокаXML = ЗаписьXML.Закрыть();

	Поток = Новый ПотокВПамяти();
	Запись = Новый ЗаписьДанных(Поток, КодировкаТекста.UTF8);
	Запись.ЗаписатьСимволы(СтрокаXML);
	Запись.Закрыть();
	Данные = Поток.ЗакрытьИПолучитьДвоичныеДанные();
	ХранилищеДанных = Новый ХранилищеЗначения(Данные, Новый СжатиеДанных());

	Группа = Справочники.Файлы.НайтиПоНаименованию("РезервныеКопииПланов", Истина, Справочники.Файлы.ПустаяСсылка());
	Если Группа.Пустая() Тогда
		Группа = Справочники.Файлы.СоздатьГруппу();
		Группа.Наименование = "РезервныеКопииПланов";
		Группа.Записать();
	ИначеЕсли Не Группа.ЭтоГруппа Тогда
		Возврат "Ошибка. Найден файл с названием ""РезервныеКопииПланов"". Переименуйте его.";
	КонецЕсли;

	Кафедра = Объект.Кафедра.Наименование;
	ДокСсылка = Справочники.Файлы.НайтиПоНаименованию(Кафедра, Истина, Группа.Ссылка);
	Если ДокСсылка.Пустая() Тогда
		Документ = Справочники.Файлы.СоздатьЭлемент();
		Документ.Наименование = Кафедра;
		Документ.Родитель = Группа.Ссылка;
	Иначе
		Документ = ДокСсылка.ПолучитьОбъект();
	КонецЕсли;
	Документ.ДанныеФайла = ХранилищеДанных;
	//Документ.ИмяФайла = Кафедра + "_" + Формат(ТекущаяДата(), "ДФ=dd-MM-yyyy-HH-mm-ss") + ".xml";
	Документ.ИмяФайла = Кафедра + " от " + Формат(ТекущаяДата(), "ДФ=dd.MM.yyyy HH.mm.ss") + ".xml";
	Документ.Записать();
КонецФункции

&НаКлиенте
Процедура СохранитьРезервнуюКопию(Команда)
	Сообщить("Диалог ""Вы точно хотите сохранить бэкап?""");
	Результат = СохранитьРезервнуюКопиюНаСервере();
	ПоказатьПредупреждение(, ?(Результат = Неопределено, "Резервная копия успешно сохранена", Результат));
КонецПроцедуры

#КонецОбласти