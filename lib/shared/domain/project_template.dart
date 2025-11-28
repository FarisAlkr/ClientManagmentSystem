import 'models/project.dart';

class ProjectTemplate {
  static List<ProjectStage> getDefaultStages() {
    return [
      ProjectStage(
        id: 'stage_1',
        title: 'שלב תיק מידע', // Information File Stage
        items: [
          const ProjectStageItem(id: 'item_1_1', title: 'מדידה מצבית'),
          const ProjectStageItem(id: 'item_1_2', title: 'מדידה למשתכן'),
          const ProjectStageItem(id: 'item_1_3', title: 'חוזה חכירה'),
          const ProjectStageItem(id: 'item_1_4', title: 'אישור זכויות'),
          const ProjectStageItem(id: 'item_1_5', title: 'צילום ת.ז'),
          const ProjectStageItem(id: 'item_1_6', title: 'תמונות מהשטח'),
          const ProjectStageItem(id: 'item_1_7', title: 'הופקה אגרת מידע'),
          const ProjectStageItem(id: 'item_1_8', title: 'אגרה שולמה'),
          const ProjectStageItem(id: 'item_1_9', title: 'שם המודד', isTextOnly: true),
          const ProjectStageItem(id: 'item_1_10', title: 'סטטוס תיק מידע', isTextOnly: true),
          const ProjectStageItem(id: 'item_1_11', title: 'מס בקשה למידע', isTextOnly: true),
        ],
      ),
      ProjectStage(
        id: 'stage_2',
        title: 'שלב תכנון', // Planning Stage
        items: [
          const ProjectStageItem(id: 'item_2_1', title: 'סקיצה ראשונית מאושרת - קרקע'),
          const ProjectStageItem(id: 'item_2_2', title: 'סקיצה ראשונית מאושרת - א'),
          const ProjectStageItem(id: 'item_2_3', title: 'סקיצה ראשונית מאושרת - ב'),
          const ProjectStageItem(id: 'item_2_4', title: 'סקיצה ראשונית מאושרת - ג'),
          const ProjectStageItem(id: 'item_2_5', title: 'הדמיה D3'),
          const ProjectStageItem(id: 'item_2_6', title: 'תמונות מרונדרות'),
        ],
      ),
      ProjectStage(
        id: 'stage_3',
        title: 'שלבי הגשה', // Submission Stages
        items: [
          const ProjectStageItem(id: 'item_3_1', title: 'תכנית הגשה + רכיב שטחים'),
          const ProjectStageItem(id: 'item_3_2', title: 'נשלח קבלת מערך הגא'),
          const ProjectStageItem(id: 'item_3_3', title: 'נשלח לקבלת מערך מים'),
          const ProjectStageItem(id: 'item_3_4', title: 'נספח ביצוע'),
          const ProjectStageItem(id: 'item_3_5', title: 'פקדון ועדה'),
          const ProjectStageItem(id: 'item_3_6', title: 'פקדון ועדה משולם'),
          const ProjectStageItem(id: 'item_3_7', title: 'סטטוס בקשה להיתר'),
          const ProjectStageItem(id: 'item_3_8', title: 'סטטוס בקרה מרחבית', isTextOnly: true),
          const ProjectStageItem(id: 'item_3_9', title: 'סטטוס תאגיד'),
          const ProjectStageItem(id: 'item_3_10', title: 'סטטוס הגא'),
          const ProjectStageItem(id: 'item_3_11', title: 'החלטת ועדה'),
          const ProjectStageItem(id: 'item_3_12', title: 'רשות העתיקות'),
          const ProjectStageItem(id: 'item_3_13', title: 'היטל השבחה'),
        ],
      ),
      ProjectStage(
        id: 'stage_4',
        title: 'בקרת תכן', // Design Control
        items: [
          const ProjectStageItem(id: 'item_4_1', title: 'רשות מקרקעי ישראל'),
          const ProjectStageItem(id: 'item_4_2', title: 'הגא'),
          const ProjectStageItem(id: 'item_4_3', title: 'הסכם אתר פסולת בנין'),
          const ProjectStageItem(id: 'item_4_4', title: 'מכון תקנים'),
          const ProjectStageItem(id: 'item_4_5', title: 'דוח קרקע'),
          const ProjectStageItem(id: 'item_4_6', title: 'כיבוי אש'),
          const ProjectStageItem(id: 'item_4_7', title: 'חישוב סטטי + טופס 9'),
          const ProjectStageItem(id: 'item_4_8', title: 'דוח עורך הבקשה'),
        ],
      ),
      ProjectStage(
        id: 'stage_5',
        title: 'היתר בניה וביצוע', // Building Permit & Execution
        items: [
          const ProjectStageItem(id: 'item_5_1', title: 'אגרה סופית'),
          const ProjectStageItem(id: 'item_5_2', title: 'אגרה סופית משולמת'),
          const ProjectStageItem(id: 'item_5_3', title: 'הפק היתר בניה'),
          const ProjectStageItem(id: 'item_5_4', title: 'תכנית כלונסאות'),
          const ProjectStageItem(id: 'item_5_5', title: 'רצפה ועמודים'),
          const ProjectStageItem(id: 'item_5_6', title: 'תקרה קרקע'),
          const ProjectStageItem(id: 'item_5_7', title: 'תקרה א'),
          const ProjectStageItem(id: 'item_5_8', title: 'תקרה ב'),
          const ProjectStageItem(id: 'item_5_9', title: 'תקרה ג'),
        ],
      ),
    ];
  }
}