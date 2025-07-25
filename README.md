# PolyScheduler – Мобильное приложение для просмотра расписания СПбПУ

<p align="center">
<img src="docs/images/polytech_logo.jpg" width="250" align="center" alt="Иконка приложения">
</p>

## О проекте

Данное мобильное приложение было разработано в рамках дисциплины "Основы проектной деятельности"в Санкт-Петербургском университете имени Петра Великого. Оно позволяет просматривать учебное расписание конкретного преподавателя, студента или аудитории, и получать подробную информацию о парах. 

Приложение реализовано с помощью фреймворка Flutter и языка программирования Dart, по принципам **Clean Architecture** (модифицированная версия Reso Coder):
- **Data**: Репозитории и источники данных
- **Domain**: Бизнес-логика и entities
- **Presentation**: BLoC + UI

## Основные используемые технологии
+ Hive для хранения данных
+ Http для взаимодействия с сетью
+ BLoC для state-management
+ Get_it для service locator

## Flutter и Dart FVM версии проекта
Flutter: 3.29.2 / Dart SDK: 3.7.2

## Демонстрация функционала приложения

<table>
    <tr>
        <td>
			<img src="https://github.com/Mark-120/poly-schedule-opd25/blob/804b06a7876753fa4d077e6f85d27132a77778fb/docs/gifs/look_schedule.gif" width="256"/>
        </td>
        <td>
			<img src="https://github.com/Mark-120/poly-schedule-opd25/blob/804b06a7876753fa4d077e6f85d27132a77778fb/docs/gifs/different_saves.gif" width="256"/>
        </td>
        <td>
			<img src="https://github.com/Mark-120/poly-schedule-opd25/blob/804b06a7876753fa4d077e6f85d27132a77778fb/docs/gifs/search_schedule.gif" width="256"/>
        </td>
    </tr>
    <tr>
        <td>
            Просмотр учебного расписания
        </td>
        <td>
            Сохранение расписаний
        </td>
        <td>
            Поиск расписаний
        </td>
    </tr>
</table>
