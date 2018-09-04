//
//  AgendaItemEditorDelegate.swift
//  Slickster
//
//  Created by NonGT on 9/28/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation

protocol AgendaItemEditorDelegate {
    
    func agendaItemEditorCategoryActivated(
        editor: AgendaItemEditorView,
        editorHeader: AgendaItemEditorHeaderView,
        templateType: String,
        activityType: String,
        typeCategories: AgendaTypeCategories!,
        eventBriteCategories: [EventbriteCategory]!,
        selectedCategory: AnyObject?,
        parentCategory: AnyObject?)
    
    func agendaItemEditorTimeActivated(
        editor: AgendaItemEditorView,
        editorHeader: AgendaItemEditorHeaderView,
        selectedTime: AgendaTime)

    func agendaItemEditorSortModeChanged(
        editor: AgendaItemEditorView,
        editorHeader: AgendaItemEditorHeaderView,
        sortMode: String)

    func agendaItemEditorDistanceChanged(
        editor: AgendaItemEditorView,
        editorHeader: AgendaItemEditorHeaderView,
        distance: Float)
}