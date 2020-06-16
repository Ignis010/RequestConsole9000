﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КопироватьДанныеФормы(Параметры.Объект, Объект);
	ДанныеФормы = Параметры.ДанныеФормы;
	Картинки = ПолучитьИзВременногоХранилища(Объект.Картинки);
	
	ТипЗначения = Неопределено;
	Если ЗначениеЗаполнено(Параметры.ТекстЗапроса) Тогда
		
		стрИмяФиктивногоПараметры = "Врп31415926";
		
		зЗапрос = Новый Запрос(Параметры.ТекстЗапроса);
		
		ТекстЗапроса = Новый ТекстовыйДокумент;
		ТекстЗапроса.УстановитьТекст(зЗапрос.Текст);
		
		стрНачальнаяСтрока = ТекстЗапроса.ПолучитьСтроку(Параметры.НачальнаяСтрока);
		стрКонечнаяСтрока = ТекстЗапроса.ПолучитьСтроку(Параметры.НачальнаяСтрока);
		стрСтрока = Лев(стрНачальнаяСтрока, Параметры.НачальнаяКолонка - 1) + "&" + стрИмяФиктивногоПараметры + Прав(стрКонечнаяСтрока, СтрДлина(стрКонечнаяСтрока) - Параметры.КонечнаяКолонка);
		
		ТекстЗапроса.ЗаменитьСтроку(Параметры.НачальнаяСтрока, стрСтрока);
		Для й = Параметры.НачальнаяСтрока + 1 По Параметры.КонечнаяСтрока Цикл
			ТекстЗапроса.УдалитьСтроку(Параметры.НачальнаяСтрока + 1);
		КонецЦикла;
		
		зЗапрос.Текст = ТекстЗапроса.ПолучитьТекст();
		
		Попытка
			КоллекцияПараметров = зЗапрос.НайтиПараметры();
			ТипЗначения = КоллекцияПараметров[стрИмяФиктивногоПараметры].ТипЗначения;
		Исключение
			//Сообщить("Отладка: " + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЕсли;
	
	сзСписокТипов = Элементы.ТипОбъекта.СписокВыбора;
	сзСписокТипов.Добавить("ВидДвиженияНакопления", "ВидДвиженияНакопления", , Картинки.Тип_ВидДвиженияНакопления);      
	сзСписокТипов.Добавить("ВидДвиженияБухгалтерии", "ВидДвиженияБухгалтерии", , Картинки.Тип_ВидДвиженияНакопления);      
	сзСписокТипов.Добавить("ВидСчета", "ВидСчета", , Картинки.Тип_ВидСчета);
	сзСписокТипов.Добавить("Справочники", "Справочник", , Картинки.Тип_СправочникСсылка);
	сзСписокТипов.Добавить("Документы", "Документ", , Картинки.Тип_ДокументСсылка);
	сзСписокТипов.Добавить("Перечисления", "Перечисление", , Картинки.Тип_ПеречислениеСсылка);
	сзСписокТипов.Добавить("ПланыВидовХарактеристик", "План видов характеристик", , Картинки.Тип_ПланВидовХарактеристикСсылка);
	сзСписокТипов.Добавить("ПланыСчетов", "План счетов", , Картинки.Тип_ПланСчетовСсылка);
	сзСписокТипов.Добавить("ПланыВидовРасчета", "План видов расчета", , Картинки.Тип_ПланВидовРасчетаСсылка);
	сзСписокТипов.Добавить("ПланыОбмена", "План обмена", , Картинки.Тип_ПланОбменаСсылка);
	сзСписокТипов.Добавить("БизнесПроцессы", "Бизнес процесс", , Картинки.Тип_БизнесПроцессСсылка);
	сзСписокТипов.Добавить("Задачи", "Задача", , Картинки.Тип_ЗадачаСсылка);
	
	Если ТипЗначения <> Неопределено Тогда
		
		маТипы = ТипЗначения.Типы();
		
		Если маТипы.Количество() <> 1 Тогда
			ТипЗначения = Неопределено;
		Иначе
			
			Тип = маТипы[0];
			
			Для Каждого эсз Из сзСписокТипов Цикл
				
				Если ТипОбъектаПеречисление(эсз.Значение) Тогда
					Если Тип = Тип(эсз.Значение) Тогда
						ТипОбъекта = эсз.Значение;
						ТипОбъектаПриИзмененииНаСервере();
						Прервать;
					КонецЕсли;
					Продолжить;
				КонецЕсли;
					
				Если Вычислить(эсз.Значение).ТипВсеСсылки().СодержитТип(Тип) Тогда
					ТипОбъекта = эсз.Значение;
					ТипОбъектаПриИзмененииНаСервере();
					ИмяОбъекта = ТипЗначения.ПривестиЗначение().Метаданные().Имя;                         
					ИмяОбъектаПриИзмененииНаСервере();
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
		
		КонецЕсли;
		
	КонецЕсли;
		
	Если ТипЗначения = Неопределено И ЗначениеЗаполнено(ДанныеФормы) Тогда
		стДанныеФормы = ПолучитьИзВременногоХранилища(ДанныеФормы);
		ТипОбъекта = стДанныеФормы.ТипОбъекта;
		ТипОбъектаПриИзмененииНаСервере();
		ИмяОбъекта = стДанныеФормы.ИмяОбъекта;
		ИмяОбъектаПриИзмененииНаСервере();
		Элемент = стДанныеФормы.Элемент;
	КонецЕсли;
	
	УстановитьДоступностьКнопок();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено(ДанныеФормы) Тогда
		ДанныеФормы = ЭтаФорма.ВладелецФормы.УникальныйИдентификатор;
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТипОбъектаПеречисление(ТипОбъекта)
	Возврат ТипОбъекта = "ВидДвиженияНакопления"
		ИЛИ ТипОбъекта = "ВидДвиженияБухгалтерии"
		ИЛИ ТипОбъекта = "ВидСчета";
КонецФункции

&НаСервере
Процедура УстановитьДоступностьКнопок()
	
	Если ТипОбъектаПеречисление(ТипОбъекта) Тогда
		Элементы.КомандаВставитьССЫЛКА.Доступность = Ложь;
		Элементы.КомандаВставитьИмя.Доступность = Истина;
		Элементы.КомандаВставитьЗНАЧЕНИЕ.Доступность = Истина;
		Элементы.КомандаВставитьПустаяСсылка.Доступность = Ложь;
	Иначе
		Элементы.КомандаВставитьССЫЛКА.Доступность = ЗначениеЗаполнено(ИмяОбъекта);
		Элементы.КомандаВставитьИмя.Доступность = ЗначениеЗаполнено(Элемент);
		Элементы.КомандаВставитьЗНАЧЕНИЕ.Доступность = Элементы.КомандаВставитьИмя.Доступность;
		Элементы.КомандаВставитьПустаяСсылка.Доступность = Элементы.КомандаВставитьССЫЛКА.Доступность;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТипОбъектаПриИзмененииНаСервере()

	сзСписокОбъектов = Элементы.ИмяОбъекта.СписокВыбора;
	сзСписокОбъектов.Очистить();
	
	Если ТипОбъекта = "ВидДвиженияНакопления" Тогда
		сзСписокОбъектов.Добавить(ВидДвиженияНакопления.Приход, "Приход");
		сзСписокОбъектов.Добавить(ВидДвиженияНакопления.Расход, "Расход");
		Элементы.ИмяОбъекта.ОграничениеТипа = Новый ОписаниеТипов("ВидДвиженияНакопления");
		ИмяОбъекта = ВидДвиженияНакопления.Приход;
	ИначеЕсли ТипОбъекта = "ВидДвиженияБухгалтерии" Тогда
		сзСписокОбъектов.Добавить(ВидДвиженияБухгалтерии.Дебет, "Дебет");
		сзСписокОбъектов.Добавить(ВидДвиженияБухгалтерии.Кредит, "Кредит");
		Элементы.ИмяОбъекта.ОграничениеТипа = Новый ОписаниеТипов("ВидДвиженияБухгалтерии");
		ИмяОбъекта = ВидДвиженияБухгалтерии.Дебет;
	ИначеЕсли ТипОбъекта = "ВидСчета" Тогда
		сзСписокОбъектов.Добавить(ВидСчета.АктивноПассивный, "Активный");
		сзСписокОбъектов.Добавить(ВидСчета.Активный, "Активный");
		сзСписокОбъектов.Добавить(ВидСчета.Пассивный, "Пассивный");
		Элементы.ИмяОбъекта.ОграничениеТипа = Новый ОписаниеТипов("ВидСчета");
		ИмяОбъекта = ВидСчета.АктивноПассивный;
	Иначе
		
		МетаданныеТипа = Метаданные[ТипОбъекта];
		Для Каждого мдОбъект Из МетаданныеТипа Цикл
			сзСписокОбъектов.Добавить(мдОбъект.Имя);
		КонецЦикла;
		
		Элементы.ИмяОбъекта.ОграничениеТипа = Новый ОписаниеТипов("Строка");
		ИмяОбъекта = "";
		
	КонецЕсли;
	
	Элементы.ИмяОбъекта.Доступность = Истина;
	ИмяОбъектаПриИзмененииНаСервере();
	УстановитьДоступностьКнопок();	
		
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	ТипОбъектаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИмяОбъектаПриИзмененииНаСервере()

	Если ТипЗнч(ИмяОбъекта) <> Тип("Строка") Тогда
		Элемент = "";
		Элементы.Элемент.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	
	сзСписокОбъектов = Элементы.Элемент.СписокВыбора;
	сзСписокОбъектов.Очистить();
	
	Если ЗначениеЗаполнено(ИмяОбъекта) Тогда
		
		Если ТипОбъекта = "Справочники" Тогда
			зЗапрос = Новый Запрос(СтрШаблон("ВЫБРАТЬ Ссылка ИЗ Справочник.%1 ГДЕ Предопределенный", ИмяОбъекта));
			маЭлементы = зЗапрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
			сзСписокОбъектов.ЗагрузитьЗначения(маЭлементы);
		ИначеЕсли ТипОбъекта = "Документы" Тогда
			зЗапрос = Новый Запрос(СтрШаблон("ВЫБРАТЬ Ссылка ИЗ Документ.%1 ГДЕ Предопределенный", ИмяОбъекта));
			маЭлементы = зЗапрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
			сзСписокОбъектов.ЗагрузитьЗначения(маЭлементы);
		ИначеЕсли ТипОбъекта = "ПланыВидовХарактеристик" Тогда
			зЗапрос = Новый Запрос(СтрШаблон("ВЫБРАТЬ Ссылка ИЗ ПланВидовХарактеристик.%1 ГДЕ Предопределенный", ИмяОбъекта));
			маЭлементы = зЗапрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
			сзСписокОбъектов.ЗагрузитьЗначения(маЭлементы);
		ИначеЕсли ТипОбъекта = "Перечисления" Тогда
			зЗапрос = Новый Запрос(СтрШаблон("ВЫБРАТЬ Ссылка ИЗ Перечисление.%1", ИмяОбъекта));
			маЭлементы = зЗапрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
			сзСписокОбъектов.ЗагрузитьЗначения(маЭлементы);
		КонецЕсли;
		
	КонецЕсли;
	
	Элемент = "";
	
	Элементы.Элемент.Доступность = НЕ ТипОбъектаПеречисление(ТипОбъекта);
	УстановитьДоступностьКнопок();	
		
КонецПроцедуры

&НаКлиенте
Процедура ИмяОбъектаПриИзменении(Элемент)
	ИмяОбъектаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеФормы()
	стДанныеФормы = Новый Структура("ТипОбъекта, ИмяОбъекта, Элемент", ТипОбъекта, ИмяОбъекта, Элемент);
	ДанныеФормы = ПоместитьВоВременноеХранилище(стДанныеФормы, ДанныеФормы);
КонецПроцедуры

&НаКлиенте
Процедура ЭлементПриИзменении(Элемент)
	УстановитьДоступностьКнопок();	
КонецПроцедуры

&НаКлиенте
Функция ТипДляЗапроса(стрТип)
	Если стрТип = "Справочники" Тогда Возврат "Справочник";
	ИначеЕсли стрТип = "Перечисления" Тогда Возврат "Перечисление";
	ИначеЕсли стрТип = "ПланыВидовХарактеристик" Тогда Возврат "ПланВидовХарактеристик";
	ИначеЕсли стрТип = "ПланыСчетов" Тогда Возврат "ПланСчетов";
	ИначеЕсли стрТип = "ПланыВидовРасчета" Тогда Возврат "ПланВидовРасчета";
	ИначеЕсли стрТип = "ПланыОбмена" Тогда Возврат "ПланОбмена";
	ИначеЕсли стрТип = "БизнесПроцессы" Тогда Возврат "БизнесПроцесс";
	ИначеЕсли стрТип = "Задачи" Тогда Возврат "Задача";
	Иначе
		Возврат стрТип;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура КомандаВставитьИмя(Команда)
	СохранитьДанныеФормы();
	Если ТипОбъектаПеречисление(ТипОбъекта) Тогда
		Закрыть(Новый Структура("ДанныеФормы, Результат", ДанныеФормы, ТипДляЗапроса(ТипОбъекта) + "." + ИмяОбъекта));
	Иначе
		Закрыть(Новый Структура("ДанныеФормы, Результат", ДанныеФормы, ТипДляЗапроса(ТипОбъекта) + "." + ИмяОбъекта + "." + Элемент));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаВставитьЗНАЧЕНИЕ(Команда)
	СохранитьДанныеФормы();                                
	Если ТипОбъектаПеречисление(ТипОбъекта) Тогда
		Закрыть(Новый Структура("ДанныеФормы, Результат", ДанныеФормы, "ЗНАЧЕНИЕ(" + ТипДляЗапроса(ТипОбъекта) + "." + ИмяОбъекта + ")"));
	Иначе
		Закрыть(Новый Структура("ДанныеФормы, Результат", ДанныеФормы, "ЗНАЧЕНИЕ(" + ТипДляЗапроса(ТипОбъекта) + "." + ИмяОбъекта + "." + Элемент + ")"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаВставитьССЫЛКА(Команда)
	СохранитьДанныеФормы();
	Закрыть(Новый Структура("ДанныеФормы, Результат", ДанныеФормы, "ССЫЛКА " + ТипДляЗапроса(ТипОбъекта) + "." + ИмяОбъекта));
КонецПроцедуры

&НаКлиенте
Процедура КомандаВставитьПустаяСсылка(Команда)
	СохранитьДанныеФормы();                                
	Закрыть(Новый Структура("ДанныеФормы, Результат", ДанныеФормы, "ЗНАЧЕНИЕ(" + ТипДляЗапроса(ТипОбъекта) + "." + ИмяОбъекта + ".ПустаяСсылка)"));
КонецПроцедуры
