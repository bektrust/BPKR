#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает действующий на указанную дату документ, удостоверяющий личность
//
// Параметры
//	ФизЛицо			- физическое лицо, для которого необходимо получить документ
//	Дата			- дата, на которую необходимо получить документ
//
// Возвращаемое значение
//	Представление		- строка - представление документа, удостоверяющего личность
//
Функция ДокументУдостоверяющийЛичностьФизлица(ФизЛицо, Дата = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизЛицо",	ФизЛицо);
	Запрос.УстановитьПараметр("ДатаСреза",	Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокументыФизическихЛиц.Представление
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.ФизЛицо КАК ФизЛицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|			И ДокументыФизическихЛиц.ФизЛицо = &ФизЛицо
	|			" + ?(Дата <> Неопределено, "И ДокументыФизическихЛиц.Период <= &ДатаСреза", "") + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.ФизЛицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.ФизЛицо = ДокументыСрез.ФизЛицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	УдостоверениеЛичности = Новый Структура("Представление, ЕстьУдостоверение");
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Представление;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Функция проверяет, является-ли указанный вид документа документом, удостоверяющим личность для этого физлица
//
// Параметры
//	ФизЛицо			- физическое лицо, для которого необходимо получить документ
//	ВидДокумента	- вид документа, удостоверяющего личность
//	Дата			- дата, на которую необходимо получить документ
//
// Возвращаемое значение
//	Является		- булево - является ли указанный вид документа документом, удостоверяющим личность
//
Функция ЯвляетсяУдостоверениемЛичности(ФизЛицо, ВидДокумента, Дата) Экспорт
	
	Если ФизЛицо.Пустая() Или ВидДокумента.Пустая() Или Не ЗначениеЗаполнено(Дата) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.Паспорт Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизЛицо",		ФизЛицо);
	Запрос.УстановитьПараметр("ВидДокумента",	ВидДокумента);
	Запрос.УстановитьПараметр("ДатаСреза",		Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокументыФизическихЛиц.ВидДокумента
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.ФизЛицо КАК ФизЛицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.ФизЛицо = &ФизЛицо
	|			И ДокументыФизическихЛиц.Период < &ДатаСреза
	|			И ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.ФизЛицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.ФизЛицо = ДокументыСрез.ФизЛицо
	|			И ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И (ДокументыФизическихЛиц.ВидДокумента = &ВидДокумента)";
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли